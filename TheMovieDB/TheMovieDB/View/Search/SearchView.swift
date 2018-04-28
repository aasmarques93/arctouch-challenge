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
    @IBOutlet var viewHeader: UIView!
    
    let viewModel = SearchViewModel.shared
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHeader.backgroundColor = HexColor.primary.color
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
    
    func pushSearchResultView(at indexPath: IndexPath) {
        let viewController = instantiate(viewController: SearchResultView.self, from: .search)
        viewController.viewModel = viewModel.searchResultViewModel(at: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchView: SearchViewModelDelegate {
    
    // MARK: - Search view model delegate -
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showError(message: String?) {
        AlertComponent.show(message: message)
    }
}
