//
//  SearchResultViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class SearchResultViewCell: UITableViewCell {
    // MARK: - Outlets -
    
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var imageViewMovie: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textViewOverview: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Model -
    
    var viewModel: SearchResultViewModel?

    // MARK: - Setup -
    
    func setupView(at indexPath: IndexPath) {
        if let value = viewModel?.movieName(at: indexPath) { labelName.text = value }
        if let value = viewModel?.movieOverview(at: indexPath) { textViewOverview.text = value }
        
        activityIndicator.startAnimating()
        imageViewMovie.sd_setImage(with: viewModel?.posterImageUrl(at: indexPath),
                                   placeholderImage: #imageLiteral(resourceName: "default-image"),
                                   options: [],
                                   progress: nil) { (image, error, type, url) in
                
                                    self.activityIndicator.isHidden = true
        }
        
        imageViewBackground.sd_setImage(with: viewModel?.backgroundImageUrl(at: indexPath), placeholderImage: #imageLiteral(resourceName: "default-image"))
    }
}
