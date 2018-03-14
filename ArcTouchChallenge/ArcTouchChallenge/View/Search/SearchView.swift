//
//  SearchView.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GenreCell"

class SearchView: UITableViewController {
    @IBOutlet var barButtonSearch: UIBarButtonItem!
    
    let viewModel = SearchViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.delegate = self
        viewModel.loadData()
    }
    
    func setupNavigationItem() {
        navigationItem.rightBarButtonItem = barButtonSearch
    }

    @IBAction func barButtonSearchAction(_ sender: UIBarButtonItem) {
        
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
        
        if let label = cell.viewWithTag(1) as? UILabel {
            if let value = viewModel.genreDescription(at: indexPath) { label.text = value }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectGenre(at: indexPath)
        performSegue(withIdentifier: SearchResultView.identifier, sender: self)
    }
}

extension SearchView: SearchViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}
