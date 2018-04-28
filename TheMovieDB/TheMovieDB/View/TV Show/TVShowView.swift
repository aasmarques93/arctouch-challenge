//
//  TVShowView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class TVShowView: UITableViewController {
    let viewModel = TVShowViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.loadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPopularList
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TVShowViewCell.self, for: indexPath)
        cell.setSelectedView(backgroundColor: UIColor.clear)
        cell.viewModel = viewModel.tvShowCellViewModel(at: indexPath)
        cell.setupView(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = instantiate(viewController: TVShowDetailView.self, from: .tvShow)
        viewController.viewModel = viewModel.tvShowDetailViewModel(at: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.doServicePaginationIfNeeded(at: indexPath)
    }
}

extension TVShowView: TVShowViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}
