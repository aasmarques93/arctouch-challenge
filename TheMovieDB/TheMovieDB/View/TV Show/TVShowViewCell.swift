//
//  TVShowViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

class TVShowViewCell: UICollectionViewCell {
    // MARK: - Outlets -
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Model -
    
    var viewModel: TVShowViewModel?
    
    // MARK: - Setup -
    
    func setupView(at section: Int, row: Int) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        imageView.sd_setImage(with: viewModel?.imagePathUrl(at: section, row: row),
                              placeholderImage: #imageLiteral(resourceName: "default-image"),
                              options: [],
                              progress: nil) { (image, error, type, url) in
            
                                self.activityIndicator.isHidden = true
        }
    }
}
