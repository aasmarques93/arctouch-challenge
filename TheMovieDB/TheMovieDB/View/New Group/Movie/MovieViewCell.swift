//
//  MovieViewCell.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import SDWebImage

class MovieViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = HomeViewModel.shared
    
    func setupView(at section: Int, row: Int) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = true
        
        if let url = viewModel.imagePathUrl(at: section, row: row) {
            imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "searching"))
        }
    }
}
