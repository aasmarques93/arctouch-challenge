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
        
        viewModel?.posterImageData(at: indexPath) { (data) in
            self.activityIndicator.isHidden =  true
            if let data = data as? Data, let image = UIImage(data: data) {
                self.imageViewMovie.image = image
            }
        }
        
        viewModel?.backgroundImageData(at: indexPath) { (data) in
            if let data = data as? Data, let image = UIImage(data: data) {
                self.imageViewBackground.image = image
            }
        }
    }
}
