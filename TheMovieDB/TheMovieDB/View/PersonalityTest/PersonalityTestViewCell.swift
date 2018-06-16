//
//  PersonalityTestViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/7/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import GhostTypewriter

class PersonalityTestViewCell: UITableViewCell {
    // MARK: - Outlets -
    
    @IBOutlet weak var labelText: TypewriterLabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Model -
    
    var viewModel: PersonalityTestCellViewModel?
    
    // MARK: - Setup -
    
    func setupView() {
        viewModel?.cellDelegate = self
        viewModel?.text.bind(to: labelText.reactive.text)
        viewModel?.loadData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        labelText.typingTimeInterval = Constants.typingTimeInterval
        labelText.startTypewritingAnimation {
            self.viewModel?.didFinishTypewriting()
        }
    }
}

extension PersonalityTestViewCell: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource -
    
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
        let cell = tableView.dequeueReusableCell(PersonalityTestAnswerViewCell.self, for: indexPath)
        cell.setSelectedView(backgroundColor: UIColor.clear)
        cell.viewModel = viewModel
        cell.setupView(at: indexPath)
        return cell
    }
}

extension PersonalityTestViewCell: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate -
    
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
            self.tableView.isUserInteractionEnabled = false
        }
    }
}

extension PersonalityTestViewCell: PersonalityTestCellDelegate {
    
    // MARK: - PersonalityTestCellDelegate -
    
    func reloadData(at row: Int) {
        tableView.isUserInteractionEnabled = false
        let indexPath = IndexPath(row: row, section: 0)
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func didFinishTypewritingAnimation() {
        tableView.isUserInteractionEnabled = true
    }
}
