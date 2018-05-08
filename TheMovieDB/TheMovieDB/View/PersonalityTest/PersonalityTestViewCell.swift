//
//  PersonalityTestViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/7/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import GhostTypewriter

private let cellIdentifier = "AnswerCell"
private let typingTimeInterval = 0.01

class PersonalityTestViewCell: UITableViewCell {
    @IBOutlet weak var labelText: TypewriterLabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PersonalityTestCellViewModel?
    
    func setupView(at indexPath: IndexPath) {
        viewModel?.cellDelegate = self
        viewModel?.text.bind(to: labelText.reactive.text)
        viewModel?.loadData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        labelText.typingTimeInterval = typingTimeInterval
        labelText.startTypewritingAnimation {
            self.viewModel?.didFinishTypewriting()
        }
    }
}

extension PersonalityTestViewCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfAnswers ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.heightForRow(at: indexPath) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.setSelectedView(backgroundColor: UIColor.clear)
        
        if let label = cell.viewWithTag(1) as? TypewriterLabel {
            label.text = viewModel?.answerTitle(at: indexPath.row)

            if let isAnswerSelected = viewModel?.isAnswerSelected(at: indexPath), isAnswerSelected {
                tableView.isUserInteractionEnabled = false
                label.textColor = HexColor.primary.color
                label.borderColor = HexColor.secondary.color
                label.backgroundColor = HexColor.secondary.color
            } else {
                tableView.isUserInteractionEnabled = true
                label.textColor = HexColor.text.color
                label.borderColor = HexColor.text.color
                label.backgroundColor = UIColor.clear
                
            }
            
            label.typingTimeInterval = typingTimeInterval
            label.startTypewritingAnimation {
                self.viewModel?.didFinishTypewriting()
            }
        }
        
        return cell
    }
}

extension PersonalityTestViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isUserInteractionEnabled = false
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let label = cell?.viewWithTag(1) as? UILabel {
            label.textColor = HexColor.primary.color
            label.backgroundColor = HexColor.secondary.color
            label.borderColor = HexColor.secondary.color
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel?.didSelectAnswer(at: indexPath.row)
        }
    }
}

extension PersonalityTestViewCell: PersonalityTestCellDelegate {
    func reloadData(at row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
