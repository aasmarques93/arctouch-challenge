//
//  PersonalityTestCellViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/7/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

protocol PersonalityTestCellDelegate: class {
    func reloadData(at row: Int)
}

protocol PersonalityTestCellViewModelDelegate: class {
    func didSelect(answer: Answer)
    func didFinishTypewriting()
    func isAnswerSelected(_ answer: Answer) -> Bool?
}

class PersonalityTestCellViewModel: ViewModel {
    weak var cellDelegate: PersonalityTestCellDelegate?
    weak var delegate: PersonalityTestCellViewModelDelegate?
    
    var text = Observable<String?>(nil)
    
    private var question: Questions?
    private var arrayAnswers = [Answer]() { didSet { cellDelegate?.reloadData(at: currentAnswerStep) } }
    var numberOfAnswers: Int { return arrayAnswers.count }
    
    private var currentAnswerStep = -1
    
    init(_ object: Questions?) {
        self.question = object
    }

    func loadData() {
        text.value = question?.title
    }
    
    func answerTitle(at index: Int) -> String? {
        return arrayAnswers[index].title
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        let answer = arrayAnswers[indexPath.row]
        let minHeight: CGFloat = 70, spacing: CGFloat = 16
        
        guard let height = answer.title?.height, height > minHeight else {
            return minHeight
        }
        
        return height + spacing
    }
    
    func isAnswerSelected(at indexPath: IndexPath) -> Bool? {
        return delegate?.isAnswerSelected(arrayAnswers[indexPath.row])
    }
    
    func didSelectAnswer(at index: Int) {
        delegate?.didSelect(answer: arrayAnswers[index])
    }
    
    func didFinishTypewriting() {
        currentAnswerStep += 1
        
        guard let answers = question?.answers, answers.count > 0 else {
            delegate?.didFinishTypewriting()
            return
        }
        
        guard currentAnswerStep < answers.count else {
            return
        }
        
        arrayAnswers.append(answers[currentAnswerStep])
    }
}
