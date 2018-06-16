//
//  HumorDetectionViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/7/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

protocol HumorDetectionViewModelDelegate: class {
    func reloadData(at row: Int)
    func didFinishSteps()
}

class PersonalityTestViewModel: ViewModel {
    weak var delegate: HumorDetectionViewModelDelegate?
    
    private var humorObject: Humor? { didSet { doDetectionStep() } }
    
    private var arrayQuestions = [Questions]() { didSet { delegate?.reloadData(at: currentStep) } }
    var numberOfQuestions: Int { return arrayQuestions.count }
    
    private var arraySelectedAnswers = [Answer]()
    
    private var currentStep: Int = -1
    
    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            JSONWrapper.json(from: .humor) { [weak self] (json) in
                self?.humorObject = Humor(json: json)
            }
        }
    }
    
    func isCurrentStepAvailable(at indexPath: IndexPath) -> Bool {
        return indexPath.row >= currentStep
    }
    
    func doDetectionStep() {
        currentStep += 1
        
        guard let questions = humorObject?.questions, currentStep < questions.count else {
            print("Did finish steps")
            delegate?.didFinishSteps()
            return
        }
        
        arrayQuestions.append(questions[currentStep])
    }
    
    func humorDetectionCellViewModel(at indexPath: IndexPath) -> HumorDetectionCellViewModel? {
        let viewModel = HumorDetectionCellViewModel(arrayQuestions[indexPath.row])
        viewModel.delegate = self
        return viewModel
    }
}

extension PersonalityTestViewModel: HumorDetectionCellViewModelDelegate {
    func didSelect(answer: Answer) {
        if let skip = answer.skip, skip, let questions = humorObject?.questions {
            currentStep = questions.count
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
