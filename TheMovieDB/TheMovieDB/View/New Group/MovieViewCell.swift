//
//  MovieViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import SDWebImage

class MovieViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: MoviesViewModel?
    
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
