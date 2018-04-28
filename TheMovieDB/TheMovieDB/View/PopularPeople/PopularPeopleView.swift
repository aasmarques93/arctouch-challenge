//
//  PopularPeopleView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class PopularPeopleView: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: CollectionView!
    
    let searchHeaderView = SearchHeaderView.instantateFromNib(title: Titles.popularPeople.rawValue,
                                                              placeholder: Messages.searchPerson.rawValue)
    
    let viewModel = PopularPeopleViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchHeaderView.delegate = self
        headerView.addSubview(searchHeaderView)
        collectionView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.collectionDelegate = self
        viewModel.delegate = self
        viewModel.loadData()
    }
}

extension PopularPeopleView: SearchHeaderViewDelegate {
    
    // MARK: - Search bar delegate -
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.doSearchPerson(with: searchBar.text)
    }
}

extension PopularPeopleView: CollectionViewDelegate {
    
    // MARK: - Collection view delegate -
    
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
        let viewController = instantiate(viewController: PersonView.self, from: .generic)
        viewController.viewModel = viewModel.personViewModel(at: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PopularPeopleView: PopularPeopleViewModelDelegate {
    
    // MARK: - Popular people view model delegate -
    
    func reloadData() {
        collectionView.reloadData()
    }
}
