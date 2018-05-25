//
//  SearchViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/25/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class SearchViewCell: UICollectionViewCell {
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelGenre: UILabel!
    
    var viewModel: SearchCellViewModel?
    
    func setupView() {
        viewModel?.photo.bind(to: imageViewPhoto.reactive.image)
        viewModel?.title.bind(to: labelGenre.reactive.text)
        
        viewModel?.loadData()
    }
}
