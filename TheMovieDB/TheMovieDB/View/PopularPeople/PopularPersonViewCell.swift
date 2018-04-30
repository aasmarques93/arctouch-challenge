//
//  PopularPersonViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

class PopularPersonViewCell: UICollectionViewCell {
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
 
    var viewModel: PopularPersonCellViewModel?
    
    func setupView(at indexPath: IndexPath) {
        activityIndicator.startAnimating()
        
        viewModel?.photo.bind(to: imageViewPhoto.reactive.image)
        viewModel?.name.bind(to: labelName.reactive.text)
        viewModel?.isActivityIndicatorHidden.bind(to: activityIndicator.reactive.isHidden)
        
        viewModel?.setupData()
    }
}
