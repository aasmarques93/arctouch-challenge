//
//  HomeView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

class HomeView: UITableViewController {
    let searchHeaderView = SearchHeaderView.instantateFromNib(title: Titles.movies.localized, placeholder: Messages.searchMovie.localized)
    let viewHeaderHeight: CGFloat = 32
    
    let viewModel = HomeViewModel()
    
    var labelHeader: UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: viewHeaderHeight))
        label.backgroundColor = HexColor.primary.color
        label.textColor = HexColor.text.color
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Singleton.shared.didSkipTestFromLauching = true
        searchHeaderView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        viewModel.delegate = self
        viewModel.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.shared.unlockOrientation()
    }
    
    // MARK: - Table view data source -
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfGenres
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return searchHeaderView.frame.height + viewHeaderHeight
        }
        return viewHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = labelHeader
        label.text = viewModel.genreTitle(at: section)
        
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0,
                                            width: SCREEN_WIDTH,
                                            height: searchHeaderView.frame.height + viewHeaderHeight))
            
            label.frame = CGRect(x: 0, y: searchHeaderView.frame.maxY, width: view.frame.width, height: viewHeaderHeight)
            
            view.addSubview(searchHeaderView)
            view.addSubview(label)
            
            return view
        }
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.isMoviesEmpty(at: indexPath) { return 44 }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(HomeViewCell.self, for: indexPath)
        cell.viewModel = viewModel
        cell.setupView(at: indexPath)
        cell.delegate = self
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        searchHeaderView.frame = CGRect(x: searchHeaderView.frame.minX,
                                        y: searchHeaderView.frame.minY,
                                        width: size.width,
                                        height: searchHeaderView.frame.height)
        tableView.reloadData()
    }
}

extension HomeView: SearchHeaderViewDelegate {
    
    // MARK: - Search bar delegate -
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmptyOrWhitespace {
            let viewController = instantiate(viewController: SearchResultView.self, from: .search)
            viewController.viewModel = viewModel.searchResultViewModel(with: searchBar.text)
            navigationController?.pushViewController(viewController, animated: true)
        }
        searchBar.text = nil
    }
}

extension HomeView: HomeViewCellDelegate {
    // MARK: - Home view cell delegate -
    
    func didSelectItem(at section: Int, row: Int) {
        let viewController = instantiate(viewController: MovieDetailView.self, from: .movie)
        viewController.viewModel = viewModel.movieDetailViewModel(at: section, row: row)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HomeView: HomeViewModelDelegate {
    
    // MARK: - Home view model delegate -
    
    func reloadData(at index: Int) {
        let indexPath = IndexPath(row: 0, section: index)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showError(message: String?) {
        AlertController.show(message: message)
    }
}
