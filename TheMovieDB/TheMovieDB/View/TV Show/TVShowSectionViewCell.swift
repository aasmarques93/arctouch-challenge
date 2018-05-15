//
//  TVShowSectionViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

protocol TVShowViewCellDelegate: class {
    func didSelectItem(at section: Int, row: Int)
}

class TVShowSectionViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: CollectionView!
    @IBOutlet weak var labelMessageError: UILabel!
    
    weak var delegate: TVShowViewCellDelegate?
    
    var viewModel: TVShowViewModel?
    var selectedIndexPath: IndexPath?
    
    func setupView(at indexPath: IndexPath) {
        if let viewModel = viewModel {
            labelMessageError.isHidden = !viewModel.isTVShowEmpty(at: indexPath)
        } else {
            labelMessageError.isHidden = true
        }
        
        selectedIndexPath = indexPath
        
        collectionView.collectionDelegate = self
        collectionView.reloadData()
        
        collectionView.itemWidth = indexPath.section == 0 ? StoryPreviewCell.cellHeight : 180
        collectionView.itemHeight = indexPath.section == 0 ? StoryPreviewCell.cellHeight : 230
    }
}

extension TVShowSectionViewCell: CollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfTVShows(at: selectedIndexPath?.section ?? 0) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard selectedIndexPath?.section != 0 else {
            let cell = collectionView.dequeueReusableCell(StoryPreviewCell.self, for: indexPath)
            cell.viewModel = viewModel
            cell.setupView(at: indexPath.row)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(TVShowViewCell.self, for: indexPath)
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
