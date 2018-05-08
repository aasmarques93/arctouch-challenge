//
//  PersonalityTestViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/7/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

protocol PersonalityTestViewModelDelegate: class {
    func reloadData(at row: Int)
    func didFinishSteps()
    func skipTest()
}

class PersonalityTestViewModel: ViewModel {
    // MARK: - Singleton -
    static let shared = PersonalityTestViewModel()
    
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: PersonalityTestViewModelDelegate?
    
    // MARK: Observables
    var progress = Observable<Float>(0)
    var pagingText = Observable<String>("")
    var resultText = Observable<String>("")
    
    // MARK: Objects
    private var personalityObject: Personality? {
        didSet {
            doDetectionStep()
            
            guard let personalityTypes = personalityObject?.personalityTypes else {
                return
            }
            
            arrayPersonalityTypes = personalityTypes
        }
    }
    
    private var arrayPersonalityTypes = [PersonalityType]()
    private var userPersonalityType: PersonalityType? {
        didSet {
            resultText.value = userPersonalityType?.text ?? ""
        }
    }
    
    private var arrayQuestions = [Questions]() { didSet { delegate?.reloadData(at: currentStep) } }
    var numberOfQuestions: Int { return arrayQuestions.count }
    var totalOfQuestions: Int? { return personalityObject?.questions?.count }
    
    private var arraySelectedAnswers = [Answer]()

    // MARK: Variables
    private var currentStep: Int = -1
    
    var userPersonalityTitle: String {
        return userPersonalityType?.title ?? ""
    }
    
    var userPersonalityText: String {
        return userPersonalityType?.text ?? "Action"
    }
    
    // MARK: - Life cycle -
    
    init() {
        userPersonalityType = Singleton.shared.userPersonalityType
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        if Singleton.shared.isPersonalityTestAnswered && !Singleton.shared.didSkipTestFromLauching {
            Singleton.shared.didSkipTestFromLauching = true
            delegate?.skipTest()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            JSONWrapper.json(from: .personalityTest) { [weak self] (json) in
                self?.personalityObject = Personality(json: json)
            }
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
            didFinishSteps()
            return
        }
        
        arrayQuestions.append(questions[currentStep])
    }
    
    private func didFinishSteps() {
        print("Did finish steps")
        discoverUserPersonality()
        delegate?.didFinishSteps()
    }
    
    private func discoverUserPersonality() {
        var counts = [Int: Int]()
        arraySelectedAnswers.forEach { (answer) in
            if let id = answer.personalityTypeId  {
                counts[id, default: 0] += 1
            }
        }
        
        let maxValue = counts.values.max()
        let item = counts.filter { return $0.value == maxValue }
        
        if let personalityTypeId = item.keys.first {
            userPersonalityType = arrayPersonalityTypes.filter { return $0.id == personalityTypeId }.first
        }
        
        userPersonalityType?.saveUserDefaults(key: Constants.UserDefaults.userPersonality)
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
        if let skip = answer.skip, skip {
            delegate?.skipTest()
            return
        }
        
        arraySelectedAnswers.append(answer)
        doDetectionStep()
    }
    
    func didFinishTypewriting() {
        doDetectionStep()
    }
    
    func isAnswerSelected(_ answer: Answer) -> Bool? {
        return !arraySelectedAnswers.filter { $0.id == answer.id }.isEmpty
    }
}
