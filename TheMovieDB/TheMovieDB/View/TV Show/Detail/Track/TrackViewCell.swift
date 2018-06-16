//
//  TrackViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/21/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class TrackViewCell: UITableViewCell {
    // MARK: - Outlets -
    
    @IBOutlet weak var collectionView: CollectionView!
    
    // MARK: - Properties -
    
    private var selectedIndexPath: IndexPath?

    // MARK: - View Model -
    
    var viewModel: TrackViewModel?
    
    // MARK: - Setup -
    
    func setupView(at indexPath: IndexPath) {
        selectedIndexPath = indexPath
        collectionView.collectionDelegate = self
        collectionView.reloadData()
        
        guard let lastIndexPathDisplayed = viewModel?.lastIndexPathDisplayed(at: indexPath.section),
            lastIndexPathDisplayed.item > 1 else {
            return
        }

        collectionView.scrollToItem(at: lastIndexPathDisplayed, at: .centeredHorizontally, animated: false)
    }
}

extension TrackViewCell: CollectionViewDelegate {
    // MARK: - CollectionViewDelegate -
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfEpisodes(at: selectedIndexPath?.section ?? 0) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(TrackEpisodeViewCell.self, for: indexPath)
        cell.viewModel = viewModel?.trackCellViewModel(at: selectedIndexPath?.section ?? 0, row: indexPath.row)
        cell.setupView()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel?.setLastIndexPathDisplayed(indexPath, at: selectedIndexPath?.section ?? 0)
    }
    
    func didSelect(_ collectionView: UICollectionView, itemAt indexPath: IndexPath) {
        viewModel?.didSelectEpisode(at: selectedIndexPath?.section ?? 0, row: indexPath.row)
    }
}
