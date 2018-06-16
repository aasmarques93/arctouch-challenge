//
//  SearchView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class SearchView: UIViewController {
    // MARK: - Outlets -
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: CollectionView!
    
    // MARK: - View Model -
    
    private let viewModel = SearchViewModel()
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.search.localized
        setupCollectionView()
        viewModel.delegate = self
        viewModel.loadData()
    }
    
    private func setupCollectionView() {
        collectionView.itemHeight = collectionView.itemWidth
        collectionView.collectionDelegate = self
        collectionView.keyboardDismissMode = .onDrag
    }
    
    private func pushSearchResultView(at indexPath: IndexPath? = nil, text: String? = nil) {
        let viewController = instantiate(viewController: SearchResultView.self, from: .search)
        viewController.viewModel = viewModel.searchResultViewModel(at: indexPath, text: text)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchView: CollectionViewDelegate {
    
    // MARK: - Collection view delegate -
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfGenres
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(SearchViewCell.self, for: indexPath)
        cell.viewModel = viewModel
        cell.setupView(at: indexPath)
        return cell
    }
    
    func didSelect(_ collectionView: UICollectionView, itemAt indexPath: IndexPath) {
        pushSearchResultView(at: indexPath)
    }
}

extension SearchView: UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate -
    
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
        collectionView.reloadData()
    }
    
    func showAlert(message: String?) {
        alertController?.show(message: message)
    }
}
