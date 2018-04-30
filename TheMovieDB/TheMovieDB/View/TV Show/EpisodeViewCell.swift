//
//  SeasonDetailViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/30/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class EpisodeViewCell: UITableViewCell {
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var labelOriginalTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var textViewOverview: UITextView!
    
    var viewModel: EpisodeViewModel?
    
    func setupView(at indexPath: IndexPath) {
        viewModel?.photo.bind(to: imageViewPoster.reactive.image)
        viewModel?.title.bind(to: labelOriginalTitle.reactive.text)
        viewModel?.date.bind(to: labelDate.reactive.text)
        viewModel?.overview.bind(to: textViewOverview.reactive.text)
        
        viewModel?.setupData()
    }
}
