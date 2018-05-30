//
//  StoryPreviewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/15/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class StoryPreviewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    static var cellSize: CGSize {
        return CGSize(width: 140, height: 180)
    }
    var viewModel: MoviesShowsViewModel?
    
    func setupView(at index: Int) {
        setupAppearance()
        imageView.sd_setImage(with: viewModel?.storyPreviewImagePathUrl(at: index), placeholderImage: #imageLiteral(resourceName: "default-image"))
        labelTitle.text = viewModel?.storyPreviewTitle(at: index)
    }
    
    private func setupAppearance() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = HexColor.text.cgColor
        
        backgroundColor = HexColor.primary.color
        imageView.backgroundColor = HexColor.primary.color
    }
}
