//
//  SearchResultViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class SearchResultViewCell: UITableViewCell {
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var imageViewMovie: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: SearchResultViewModel?
    
    func setupView(at indexPath: IndexPath) {
        if let value = viewModel?.movieName(at: indexPath) { labelName.text = value }
        
        activityIndicator.startAnimating()
        if let url = viewModel?.posterImageUrl(at: indexPath) {
            imageViewMovie.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "default-image"), options: [], progress: nil) { (image, error, type, url) in
                self.activityIndicator.isHidden = true
            }
        }
        
        if let url = viewModel?.backgroundImageUrl(at: indexPath) {
            imageViewBackground.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "default-image"))
        }
    }
}
