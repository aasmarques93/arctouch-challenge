//
//  TrackEpisodeViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/22/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class TrackEpisodeViewCell: UICollectionViewCell {
    // MARK: - Outlets -
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Model  -
    
    var viewModel: TrackEpisodeCellViewModel?
    
    // MARK: - Setup -
    
    func setupView() {
        viewModel?.contentAlpha.bind(to: viewContent.reactive.alpha)
        viewModel?.title.bind(to: labelTitle.reactive.text)
        viewModel?.loadData()
        
        if let isSelected = viewModel?.isSelected, isSelected {
            imageView.layer.borderColor = HexColor.secondary.cgColor
        } else {
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        imageView.sd_setImage(with: viewModel?.imagePathUrl,
                              placeholderImage: #imageLiteral(resourceName: "default-image"),
                              options: [],
                              progress: nil) { (image, error, type, url) in
            
                                self.activityIndicator.isHidden = true
        }
    }
}
