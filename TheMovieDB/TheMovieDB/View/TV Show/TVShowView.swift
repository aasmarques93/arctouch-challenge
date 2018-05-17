//
//  TVShowView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class TVShowView: UITableViewController {
    let searchHeaderView = SearchHeaderView.instantateFromNib(placeholder: Messages.searchTVShow.localized)
    let viewHeaderHeight: CGFloat = 32
    
    let viewModel = TVShowViewModel(isMovie: false)

    var labelHeader: UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: viewHeaderHeight))
        label.backgroundColor = HexColor.primary.color
        label.textColor = HexColor.text.color
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.tvShows.localized
        searchHeaderView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        viewModel.delegate = self
        viewModel.loadData()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? searchHeaderView.frame.height + viewHeaderHeight : viewHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = labelHeader
        label.text = viewModel.sectionTitle(at: section)
        
        guard section == 0 else {
            return label
        }
        
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0,
                                              width: SCREEN_WIDTH,
                                              height: searchHeaderView.frame.height + viewHeaderHeight))
        
        label.frame = CGRect(x: viewHeader.frame.minX,
                             y: searchHeaderView.frame.height,
                             width: viewHeader.frame.width,
                             height: label.frame.height)
        
        viewHeader.addSubview(searchHeaderView)
        viewHeader.addSubview(label)
        
        return viewHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.isTVShowEmpty(at: indexPath) { return 44 }
        guard indexPath.section != 0 else {
            return StoryPreviewCell.cellHeight
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TVShowSectionViewCell.self, for: indexPath)
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

extension TVShowView: SearchHeaderViewDelegate {
    
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

extension TVShowView: TVShowViewCellDelegate {
    
    // MARK: - TV Show view cell delegate -
    
    func didSelectItem(at section: Int, row: Int) {
        guard section != 0 else {
            viewModel.loadVideos(at: row)
            return
        }
        let viewController = instantiate(viewController: TVShowDetailView.self, from: .tvShow)
        viewController.viewModel = viewModel.tvShowDetailViewModel(at: section, row: row)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension TVShowView: MoviesShowsViewModelDelegate {
    
    // MARK: - TV Show view model delegate -
    
    func reloadData(at index: Int) {
        let indexPath = IndexPath(row: 0, section: index)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showError(message: String?) {
        alertController?.show(message: message)
    }
    
    func openPreview(storiesViewModel: StoriesViewModel) {
        let storiesPageViewController = instantiate(viewController: StoriesPageViewController.self, from: .generic)
        storiesPageViewController.modalPresentationStyle = .overFullScreen
        storiesPageViewController.viewModel = storiesViewModel
        present(storiesPageViewController, animated: true, completion: nil)
    }
}
