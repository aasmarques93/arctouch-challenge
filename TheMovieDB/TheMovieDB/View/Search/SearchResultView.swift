//
//  SearchResultView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class SearchResultView: UITableViewController {
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var viewModel: SearchResultViewModel?
    
    // MARK: - Life cycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTitle(text: viewModel?.titleDescription)
        viewModel?.delegate = self
        viewModel?.loadData()
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        viewModel?.doFilter(index: sender.selectedSegmentIndex)
    }
    
    // MARK: - Table view data source -

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let isMultipleSearch = viewModel?.isMultipleSearch, isMultipleSearch { return viewHeader.frame.height }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let isMultipleSearch = viewModel?.isMultipleSearch, isMultipleSearch {
            viewHeader.backgroundColor = HexColor.primary.color
            return viewHeader
        }
        return nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfSearchResults ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SearchResultViewCell.self, for: indexPath)
        cell.viewModel = viewModel
        cell.alternateBackground(at: indexPath, secondaryColor: HexColor.secondary.color.withAlphaComponent(0.1))
        cell.setSelectedView(backgroundColor: HexColor.secondary.color)
        cell.setupView(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = instantiate(viewController: MovieDetailView.self, from: .movie)
        viewController.viewModel = viewModel?.movieDetailViewModel(at: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel?.doServicePaginationIfNeeded(at: indexPath)
    }
}

extension SearchResultView: ViewModelDelegate {
    
    // MARK: - Search view model delegate -
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showError(message: String?) {
        AlertController.show(message: message, mainAction: {
            self.navigationController?.popViewController(animated: true)
        })
    }
}
