//
//  SearchView.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GenreCell"

class SearchView: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let viewModel = SearchViewModel.shared
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.delegate = self
        viewModel.loadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfGenres
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.setSelectedView(backgroundColor: HexColor.secondary.color)
        
        if let label = cell.viewWithTag(1) as? UILabel {
            if let value = viewModel.titleDescription(at: indexPath) { label.text = value }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectGenre(at: indexPath)
        performSegue(withIdentifier: SearchResultView.identifier, sender: self)
    }
}

extension SearchView: SearchViewModelDelegate {
    
    // MARK: - Search view model delegate -
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadMoviesList() {
        performSegue(withIdentifier: SearchResultView.identifier, sender: self)
    }
    
    func showError(message: String?) {
        AlertComponent.show(message: message)
    }
}

extension SearchView: UISearchBarDelegate {
    
    // MARK: - Search bar delegate -
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.doSearchMovies(with: searchBar.text)
        searchBar.text = nil
    }
}
