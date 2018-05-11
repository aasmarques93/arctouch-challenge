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
    @IBOutlet var viewFooter: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelPage: UILabel!
    
    let viewModel = PersonalityTestViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.shared.lockOrientation()
        viewModel.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTitle(text: Titles.personalityTest.localized)
    }
    
    func setupBindings() {
        viewModel.progress.bind(to: progressView.reactive.progress)
        viewModel.pagingText.bind(to: labelPage.reactive.text)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewFooter.frame.height
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewFooter
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let spacing: CGFloat = 16
        return SCREEN_HEIGHT - (navigationController?.navigationBar.frame.height ?? 0) - viewFooter.frame.height - spacing
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
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadData(at row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func didFinishSteps(animated: Bool) {
        let viewController = instantiate(viewController: PersonalityTestResultView.self, from: .personalityTest)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func skipTest() {
        performSegue(withIdentifier: HomeView.identifier, sender: self)
    }
}

