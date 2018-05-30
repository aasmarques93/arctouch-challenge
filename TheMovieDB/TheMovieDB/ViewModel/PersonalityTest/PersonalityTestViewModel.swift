//
//  PersonalityTestViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/7/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

protocol PersonalityTestViewModelDelegate: ViewModelDelegate {
    func reloadData(at row: Int)
    func didFinishSteps(animated: Bool)
    func skipTest()
}

class PersonalityTestViewModel: ViewModel {
    // MARK: - Properties -
    private let serviceModel = PersonalityTestServiceModel()
    
    // MARK: Delegate
    weak var delegate: PersonalityTestViewModelDelegate?
    
    // MARK: Observables
    var progress = Observable<Float>(0)
    var pagingText = Observable<String>("")
    var resultText = Observable<String>("")
    
    // MARK: Objects
    private var personalityObject: Personality?
    private var arrayPersonalityTypes: [PersonalityType] {
        return Singleton.shared.arrayPersonalityTypes
    }
    private var userPersonalityType = Singleton.shared.userPersonalityType
    
    private var arrayQuestions = [Questions]()
    var numberOfQuestions: Int { return arrayQuestions.count }
    var totalOfQuestions: Int? { return personalityObject?.questions?.count }
    
    private var arraySelectedAnswers = [Answer]()

    // MARK: Variables
    private var currentStep: Int = -1
    private var isTestingAgain = false
    private var isGoingToPresentTest = false
    
    var userPersonalityTitle: String {
        return userPersonalityType?.title ?? ""
    }
    
    var userPersonalityText: String {
        return userPersonalityType?.text ?? "Action"
    }
    
    private var dictionaryAnswersCounts: [Int: Int] {
        var dictionary = Singleton.shared.dictionaryAnswersCounts(at: arraySelectedAnswers)
        
        if dictionary.isEmpty {
            dictionary = Singleton.shared.dictionaryAnswersCounts()
        }
        
        return dictionary
    }
    
    // MARK: - Life cycle -
    
    init() {
        loadPersonalityTypes()
        loadTest()
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        if isTestingAgain {
            isTestingAgain = false
            doDetectionStep()
            return
        }
        
        isGoingToPresentTest = false
        
        if !Singleton.shared.didSkipTestFromLauching && (Singleton.shared.isPersonalityTestAnswered || Singleton.shared.didSkipTest) {
            skipTest()
            return
        }
        
        if Singleton.shared.isPersonalityTestAnswered {
            didFinishSteps(animated: false)
            return
        }
        
        isTestingAgain = false
        isGoingToPresentTest = true
    }
    
    private func loadPersonalityTypes() {
        guard Singleton.shared.arrayPersonalityTypes.isEmpty else {
            return
        }
        let requestUrl: RequestUrl = Singleton.shared.isLanguagePortuguese ? .personalityTypesBR : .personalityTypes
        serviceModel.getPersonality(requestUrl: requestUrl) { (object) in
            guard let results = object.personalityTypes else {
                return
            }
            Singleton.shared.arrayPersonalityTypes = results
        }
    }
    
    private func loadTest() {
        guard personalityObject == nil else {
            return
        }
        let requestUrl: RequestUrl = Singleton.shared.isLanguagePortuguese ? .personalityTestBR : .personalityTest
        serviceModel.getPersonality(requestUrl: requestUrl) { [weak self]  (object) in
            self?.personalityObject = object
            
            guard let isGoingToPresentTest = self?.isGoingToPresentTest, isGoingToPresentTest else {
                return
            }
            
            if let questions = self?.personalityObject?.questions {
                Singleton.shared.arrayPersonalityQuestions = questions
            }
            
            self?.doDetectionStep()
        }
    }
    
    // MARK: - View Model -
    
    func isCurrentStepAvailable(at indexPath: IndexPath) -> Bool {
        return indexPath.row >= currentStep
    }
    
    private func setupProgress() {
        guard let count = personalityObject?.questions?.count, currentStep > 0 else {
            return
        }
        
        let total = count - 1, step = currentStep - 1
        progress.value = Float(step) / Float(total)
        pagingText.value = "\(step)/\(total)"
    }
    
    func doDetectionStep() {
        currentStep += 1
        setupProgress()
        
        guard let questions = personalityObject?.questions, currentStep < questions.count else {
            didFinishSteps(animated: true)
            return
        }
        
        arrayQuestions.append(questions[currentStep])
        delegate?.reloadData(at: currentStep)
    }
    
    private func didFinishSteps(animated: Bool) {
        print("Did finish steps")
        discoverUserPersonality()
        resultText.value = userPersonalityType?.text ?? ""
        delegate?.didFinishSteps(animated: animated)
    }
    
    private func skipTest() {
        if userPersonalityType == nil { saveSkipTest(status: true) }
        delegate?.skipTest()
    }
    
    func doTestAgain() {
        isTestingAgain = true
        currentStep = -1
        progress.value = 0
        pagingText.value = ""
        arrayQuestions = [Questions]()
        arraySelectedAnswers = [Answer]()
        delegate?.reloadData?()
    }
    
    // MARK: - Personality Type -
    
    private func discoverUserPersonality() {
        saveUserPersonalityType()
        saveSkipTest(status: false)
        saveAnsweredQuestions()
    }
    
    // MARK: - User Defaults -
    
    private func saveUserPersonalityType() {
        let maxValue = dictionaryAnswersCounts.values.max()
        let item = dictionaryAnswersCounts.filter { $0.value == maxValue }
        
        if let personalityTypeId = item.keys.first {
            userPersonalityType = arrayPersonalityTypes.filter { $0.id == personalityTypeId }.first
        }
        
        let message = Messages.didAnsweredPersonalityTest.localized
        FabricUtils.logEvent(message: "\(message)\(userPersonalityType?.title ?? "")")
        
        Singleton.shared.savePersonalityType(userPersonalityType)
        saveUserPersonalityTest()
    }
    
    private func saveUserPersonalityTest() {
        guard let userPersonalityType = userPersonalityType, arraySelectedAnswers.count > 0 else {
            return
        }
        
        Singleton.shared.saveUserPersonalityTest(dictionaryAnswersCounts: dictionaryAnswersCounts,
                                                 personalityType: userPersonalityType)
    }
    
    private func saveSkipTest(status: Bool) {
        UserDefaultsHelper.save(object: status, key: .didSkipTest)
    }
    
    private func saveAnsweredQuestions() {
        guard arraySelectedAnswers.count > 0 else {
            return
        }
        
        let array = arraySelectedAnswers.map { $0.dictionaryRepresentation() }
        UserDefaultsHelper.save(object: array, key: .answeredQuestions)
    }
    
    func personalityTestCellViewModel(at indexPath: IndexPath) -> PersonalityTestCellViewModel? {
        let viewModel = PersonalityTestCellViewModel(arrayQuestions[indexPath.row])
        viewModel.delegate = self
        return viewModel
    }
}

extension PersonalityTestViewModel: PersonalityTestCellViewModelDelegate {
    
    // MARK: - Personality test cell view model delegate -
    
    func didSelect(answer: Answer) {
        arraySelectedAnswers.append(answer)
        
        if let skip = answer.skip, skip {
            skipTest()
            return
        }
        
        doDetectionStep()
    }
    
    func didFinishTypewriting() {
        doDetectionStep()
    }
    
    func isAnswerSelected(_ answer: Answer) -> Bool? {
        return !arraySelectedAnswers.filter { $0.id == answer.id }.isEmpty
    }
}
