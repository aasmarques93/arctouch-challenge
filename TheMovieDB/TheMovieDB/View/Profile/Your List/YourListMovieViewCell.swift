//
//  YourListMovieViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/19/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class YourListMovieViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: YourListViewModel?
    
    func setupView(at indexPath: IndexPath) {
        activityIndicator.startAnimating()
        guard let url = viewModel?.imagePathUrl(at: indexPath) else {
            return
        }
        activityIndicator.isHidden = false
        imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "default-image"), options: [], progress: nil) { (image, error, type, url) in
            self.activityIndicator.isHidden = true
        }
    }
}