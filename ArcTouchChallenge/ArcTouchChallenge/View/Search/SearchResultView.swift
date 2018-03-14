//
//  SearchResultView.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ResultCell"

class SearchResultView: UITableViewController {
    let viewModel = SearchViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.loadMoviesForSelectedGenre()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppearance()
    }
    
    func setupAppearance() {
        navigationItem.titleView = nil
        self.title = viewModel.genreDescription()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMovies
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchResultViewCell
        cell.setupView(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = instantiateFrom(storyboard: .main, identifier: MovieDetailView.identifier) as! MovieDetailView
        viewController.viewModel = viewModel.movieDetailViewModel(at: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchResultView: SearchViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}
