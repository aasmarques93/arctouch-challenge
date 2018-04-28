//
//  SearchResultView.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class SearchResultView: UITableViewController {
    let viewModel = SearchViewModel.shared
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.loadMoviesForSelectedGenre()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppearance()
    }
    
    // MARK: - Appearance -
    
    func setupAppearance() {
        navigationItem.titleView = nil
        self.title = viewModel.titleDescription()
    }

    // MARK: - Table view data source -

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMovies
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SearchResultViewCell.self, for: indexPath)
        cell.alternateBackground(at: indexPath, secondaryColor: HexColor.secondary.color.withAlphaComponent(0.1))
        cell.setSelectedView(backgroundColor: HexColor.secondary.color)
        cell.setupView(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = instantiate(viewController: MovieDetailView.self)
        viewController.viewModel = viewModel.movieDetailViewModel(at: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchResultView: SearchViewModelDelegate {
    
    // MARK: - Search view model delegate -
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadMoviesList() {
        tableView.reloadData()
    }
    
    func showError(message: String?) {
        AlertComponent.show(message: message)
    }
}
