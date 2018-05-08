//
//  SearchView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GenreCell"

class SearchView: UITableViewController {
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let viewModel = SearchViewModel()
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Singleton.shared.isPersonalityTestAnswered {
            navigationItem.rightBarButtonItem = nil
        }
        
        tableView.keyboardDismissMode = .onDrag
        viewHeader.backgroundColor = HexColor.primary.color
        viewModel.delegate = self
        loadData()
    }
    
    func loadData() {
        viewModel.loadData(genreIndex: segmentedControl.selectedSegmentIndex)
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        loadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfGenres
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewHeader.frame.height
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewHeader
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
        pushSearchResultView(at: indexPath)
    }
    
    func pushSearchResultView(at indexPath: IndexPath? = nil, text: String? = nil) {
        let viewController = instantiate(viewController: SearchResultView.self, from: .search)
        viewController.viewModel = viewModel.searchResultViewModel(at: indexPath, text: text)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmptyOrWhitespace {
            pushSearchResultView(text: text)
        }
        view.endEditing(true)
        searchBar.text = nil
    }
}

extension SearchView: ViewModelDelegate {
    
    // MARK: - Search view model delegate -
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showError(message: String?) {
        AlertComponent.show(message: message)
    }
}
