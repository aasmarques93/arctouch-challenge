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
    
    var viewModel: HomeViewModel?
    
    func setupView(at section: Int, row: Int) {
        activityIndicator.startAnimating()
        if let url = viewModel?.imagePathUrl(at: section, row: row) {
            activityIndicator.isHidden = false
            imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "default-image"), options: [], progress: nil) { (image, error, type, url) in
                self.activityIndicator.isHidden = true
            }
        }
    }
}
