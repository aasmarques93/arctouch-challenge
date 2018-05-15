//
//  StoryPreviewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/15/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class StoryPreviewCell: UICollectionViewCell {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: MoviesViewModel?
    
    func setupView(at index: Int) {
        viewBackground.borderWidth = 2.0
        viewBackground.borderColor = HexColor.secondary.color
        backgroundColor = HexColor.primary.color
        imageView.backgroundColor = HexColor.primary.color
        
        if let url = viewModel?.storyPreviewImagePathUrl(at: index) {
            imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "default-image"), options: [], completed: nil)
        }
    }
}
