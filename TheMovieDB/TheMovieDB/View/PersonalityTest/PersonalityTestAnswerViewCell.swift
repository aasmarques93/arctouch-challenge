//
//  PersonalityTestAnswerViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/30/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import GhostTypewriter

class PersonalityTestAnswerViewCell: UITableViewCell {
    // MARK: - Outlets -
    
    @IBOutlet weak var labelAnswer: TypewriterLabel!
    
    // MARK: - View Model -
    
    var viewModel: PersonalityTestCellViewModel?
    
    // MARK: - Setup -
    
    func setupView(at indexPath: IndexPath) {
        labelAnswer.text = viewModel?.answerTitle(at: indexPath.row)
        
        if let isAnswerSelected = viewModel?.isAnswerSelected(at: indexPath), isAnswerSelected {
            labelAnswer.textColor = HexColor.primary.color
            labelAnswer.borderColor = HexColor.secondary.color
            labelAnswer.backgroundColor = HexColor.secondary.color
        } else {
            labelAnswer.textColor = HexColor.text.color
            labelAnswer.borderColor = HexColor.text.color
            labelAnswer.backgroundColor = UIColor.clear
        }
        
        labelAnswer.typingTimeInterval = Constants.typingTimeInterval
        labelAnswer.startTypewritingAnimation {
            self.viewModel?.didFinishTypewriting()
        }
    }
}
