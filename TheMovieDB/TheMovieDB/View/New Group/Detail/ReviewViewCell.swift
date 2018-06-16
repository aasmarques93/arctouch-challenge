//
//  ReviewViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/30/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class ReviewViewCell: UITableViewCell {
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    
    var viewModel: MovieDetailViewModel?
    
    func setupView(at indexPath: IndexPath) {
        labelAuthor.text = viewModel?.reviewAuthor(at: indexPath.row)
        labelContent.text = viewModel?.reviewContent(at: indexPath.row)
    }
}
