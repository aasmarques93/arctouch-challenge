//
//  SearchResultViewCell.swift
//  Challenge
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
        
        imageViewMovie.image = #imageLiteral(resourceName: "default-image")
        activityIndicator.startAnimating()
        viewModel?.posterImageData(at: indexPath) { [weak self] (data) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.activityIndicator.isHidden = true
            if let data = data as? Data, let image = UIImage(data: data) {
                strongSelf.imageViewMovie.image = image
            }
        }
        
        viewModel?.backgroundImageData(at: indexPath) { [weak self] (data) in
            guard let strongSelf = self else {
                return
            }
            
            if let data = data as? Data, let image = UIImage(data: data) {
                strongSelf.imageViewBackground.image = image
            }
        }
    }
}
