//
//  SearchViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/25/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class SearchViewCell: UICollectionViewCell {
    // MARK: - Outlets -
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelGenre: UILabel!
    
    // MARK: - View Model -
    
    var viewModel: SearchViewModel?
    
    // MARK: - Setup -
    
    func setupView(at indexPath: IndexPath) {
        labelGenre.text = viewModel?.titleGenre(at: indexPath)
        imageViewPhoto.sd_setImage(with: viewModel?.imageUrl(at: indexPath))
    }
}
