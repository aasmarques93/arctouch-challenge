//
//  HomeView.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

private let reuseIdentifier = "HomeCell"

class HomeView: UITableViewController {
    @IBOutlet weak var labelHeaderSection: UILabel!
    
    let viewModel = HomeViewModel.shared
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.loadData()
    }
    
    // MARK: - Table view data source -
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfGenres
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return labelHeaderSection.frame.height
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: labelHeaderSection.frame)
        label.backgroundColor = HexColor.primary.color
        label.textColor = HexColor.text.color
        label.font = labelHeaderSection.font
        label.text = viewModel.genreTitle(at: section)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.isMoviesEmpty(at: indexPath) { return 44 }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HomeViewCell
        cell.setupView(at: indexPath)
        cell.delegate = self
        return cell
    }
}

extension HomeView: HomeViewCellDelegate {
    // MARK: - Home view cell delegate -
    
    func didSelectItem(at section: Int, row: Int) {
        let viewController = instantiateFrom(storyboard: .main, identifier: MovieDetailView.identifier) as! MovieDetailView
        viewController.viewModel = viewModel.movieDetailViewModel(at: section, row: row)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HomeView: HomeViewModelDelegate {
    
    // MARK: - Home view model delegate -
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showError(message: String?) {
        AlertComponent.show(message: message)
    }
}
