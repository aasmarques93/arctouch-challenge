//
//  MovieViewCell.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class MovieViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = HomeViewModel.shared
    
    func setupView(at section: Int, row: Int) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        viewModel.imageData(at: section, row: row) { (data) in
            if let data = data as? Data, let image = UIImage(data: data) {
                self.activityIndicator.isHidden = true
                self.imageView.image = image
            } else {
                self.imageView.image = #imageLiteral(resourceName: "searching-movie")
            }
        }
    }
}
