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
    // MARK: - Singleton -
    static let shared = PersonalityTestViewModel()
    
    // MARK: - Properties -
    let serviceModel = PersonalityTestServiceModel()
    
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
    
    var userPersonalityTitle: String {
        return userPersonalityType?.title ?? ""
    }
    
    var userPersonalityText: String {
        return userPersonalityType?.text ?? "Action"
    }
    
    var dictionaryAnswersCounts: [Int: Int] {
        var dictionary = Singleton.shared.dictionaryAnswersCounts(at: arraySelectedAnswers)
        
        if dictionary.isEmpty {
            dictionary = Singleton.shared.dictionaryAnswersCounts()
        }
        
        return dictionary
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        loadPersonalityTypes()
        loadTest()
        
        if Singleton.shared.isPersonalityTestAnswered && !Singleton.shared.didSkipTestFromLauching && !isTestingAgain {
            skipTest()
            return
        }
        
        if let didSkipTest = Singleton.shared.didSkipTest, !didSkipTest && !isTestingAgain {
            didFinishSteps(animated: false)
            return
        }
        
        isTestingAgain = false
        doDetectionStep()
    }
    
    private func loadPersonalityTypes() {
        guard Singleton.shared.arrayPersonalityTypes.isEmpty else {
            return
        }
        serviceModel.getPersonality(requestUrl: Singleton.shared.isLanguagePortuguese ? .personalityTypesBR : .personalityTypes) { (object) in    
            guard let object = object as? Personality, let results = object.personalityTypes else {
                return
            }
            Singleton.shared.arrayPersonalityTypes = results
        }
    }
    
    private func loadTest() {
        guard personalityObject == nil else {
            return
        }
        serviceModel.getPersonality(requestUrl: Singleton.shared.isLanguagePortuguese ? .personalityTestBR : .personalityTest) { [weak self]  (object) in
            self?.personalityObject = object as? Personality
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
        let item = dictionaryAnswersCounts.filter { return $0.value == maxValue }
        
        if let personalityTypeId = item.keys.first {
            userPersonalityType = arrayPersonalityTypes.filter { return $0.id == personalityTypeId }.first
        }
        
        let message = Messages.didAnsweredPersonalityTest.localized
        FabricUtils.logEvent(message: "\(message)\(userPersonalityType?.title ?? "")")
        
        UserDefaultsWrapper.saveUserDefaults(object: userPersonalityType?.dictionaryRepresentation(), key: .userPersonality)
    }
    
    private func saveSkipTest(status: Bool) {
        UserDefaultsWrapper.saveUserDefaults(object: status, key: .didSkipTest)
    }
    
    private func saveAnsweredQuestions() {
        guard arraySelectedAnswers.count > 0 else {
            return
        }
        
        let array = arraySelectedAnswers.map { return $0.dictionaryRepresentation() }
        UserDefaultsWrapper.saveUserDefaults(object: array, key: .answeredQuestions)
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
