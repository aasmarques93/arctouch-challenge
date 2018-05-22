//
//  YourListViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/19/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class YourListViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: CollectionView!
    @IBOutlet weak var labelMessageError: UILabel!
        
    var viewModel: YourListViewModel?
    
    func setupView() {
        if let viewModel = viewModel {
            viewModel.delegate = self
            viewModel.loadData()
            
            viewModel.isMessageErrorHidden.bind(to: labelMessageError.reactive.isHidden)
        }
        
        collectionView.collectionDelegate = self
        collectionView.reloadData()
    }
}

extension YourListViewCell: ViewModelDelegate {
    func reloadData() {
        collectionView.reloadData()
    }
}

extension YourListViewCell: CollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfMoviesShows ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(YourListMovieViewCell.self, for: indexPath)
        cell.viewModel = viewModel
        cell.setupView(at: indexPath)
        return cell
    }
    
    func didSelect(_ collectionView: UICollectionView, itemAt indexPath: IndexPath) {
        guard let isMovieType = viewModel?.isMovieType, isMovieType else {
            let viewController = instantiate(viewController: TVShowDetailView.self, from: .tvShow)
            viewController.viewModel = viewModel?.tvShowDetailViewModel(at: indexPath)
            UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
            return
        }
        
        let viewController = instantiate(viewController: MovieDetailView.self, from: .movie)
        viewController.viewModel = viewModel?.movieDetailViewModel(at: indexPath)
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
}

