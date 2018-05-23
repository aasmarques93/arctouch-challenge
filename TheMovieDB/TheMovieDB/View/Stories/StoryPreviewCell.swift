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
    
    static var cellHeight: CGFloat = 140
    var viewModel: MoviesShowsViewModel?
    
    func setupView(at index: Int) {
        viewBackground.borderWidth = 1.0
        viewBackground.borderColor = HexColor.secondary.color
        viewBackground.layer.masksToBounds = true
        viewBackground.layer.cornerRadius = viewBackground.frame.width / 2
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
        
        backgroundColor = HexColor.primary.color
        imageView.backgroundColor = HexColor.primary.color
        
        if let url = viewModel?.storyPreviewImagePathUrl(at: index) {
            imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "default-image"), options: [], completed: nil)
        }
    }
}
