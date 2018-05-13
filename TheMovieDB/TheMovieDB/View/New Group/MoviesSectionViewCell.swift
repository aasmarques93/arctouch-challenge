//
//  MoviesViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

protocol MoviesViewCellDelegate: class {
    func didSelectItem(at section: Int, row: Int)
}

class MoviesSectionViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: CollectionView!
    @IBOutlet weak var labelMessageError: UILabel!
    
    weak var delegate: MoviesViewCellDelegate?
    
    var viewModel: MoviesViewModel?
    var selectedIndexPath: IndexPath?
    
    func setupView(at indexPath: IndexPath) {
        if let viewModel = viewModel {
            labelMessageError.isHidden = !viewModel.isMoviesEmpty(at: indexPath)
        } else {
            labelMessageError.isHidden = true
        }
        
        selectedIndexPath = indexPath
        
        collectionView.collectionDelegate = self
        collectionView.reloadData()
    }
}

extension MoviesSectionViewCell: CollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfMovies(at: selectedIndexPath?.section ?? 0) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MovieViewCell.self, for: indexPath)
        cell.viewModel = viewModel
        cell.setupView(at: selectedIndexPath?.section ?? 0, row: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel?.doServicePaginationIfNeeded(at: selectedIndexPath?.section ?? 0, row: indexPath.row)
    }
    
    func didSelect(_ collectionView: UICollectionView, itemAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: selectedIndexPath?.section ?? 0, row: indexPath.row)
    }
}
