//
//  PopularPeopleView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class PopularPeopleView: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: CollectionView!
    
    let viewModel = PopularPeopleViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.collectionDelegate = self
        viewModel.delegate = self
        viewModel.loadData()
    }
}

extension PopularPeopleView: UISearchBarDelegate {
    // MARK: - Search bar delegate -
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.doSearchPerson(with: searchBar.text)
    }
}

extension PopularPeopleView: CollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPopularPeople
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PopularPersonViewCell.self, for: indexPath)
        cell.viewModel = viewModel.popularPersonCellViewModel(at: indexPath)
        cell.setupView(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.doServicePaginationIfNeeded(at: indexPath)
    }
    
    func didSelect(_ collectionView: UICollectionView, itemAt indexPath: IndexPath) {
        let viewController = instantiate(viewController: PersonView.self)
        viewController.viewModel = viewModel.personViewModel(at: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PopularPeopleView: PopularPeopleViewModelDelegate {
    func reloadData() {
        collectionView.reloadData()
    }
}
