//
//  PersonalityTestView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/7/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import GhostTypewriter

class PersonalityTestView: UITableViewController {
    let viewModel = PersonalityTestViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let spacing: CGFloat = 16
        return SCREEN_HEIGHT - (navigationController?.navigationBar.frame.height ?? 0) - spacing
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfQuestions
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(PersonalityTestViewCell.self, for: indexPath)
        cell.viewModel = viewModel.personalityTestCellViewModel(at: indexPath)
        cell.setupView(at: indexPath)
        return cell
    }
}

extension PersonalityTestView: PersonalityTestViewModelDelegate {
    func reloadData(at row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func didFinishSteps() {
        performSegue(withIdentifier: HomeView.identifier, sender: self)
    }
}

