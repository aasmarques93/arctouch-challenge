//
//  SeasonDetailViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/30/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class EpisodeViewCell: UITableViewCell {
    // MARK: - Outlets -
    
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var labelOriginalTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var textViewOverview: UITextView!
    @IBOutlet weak var buttonPhoto: UIButton!

    // MARK: - View Model -
    
    var viewModel: EpisodeViewModel?
    
    // MARK: - Setup -
    
    func setupView() {
        imageViewPoster.sd_setImage(with: viewModel?.imageUrl, placeholderImage: #imageLiteral(resourceName: "default-image"))
        
        viewModel?.title.bind(to: labelOriginalTitle.reactive.text)
        viewModel?.date.bind(to: labelDate.reactive.text)
        viewModel?.overview.bind(to: textViewOverview.reactive.text)
        
        viewModel?.loadData()
    }
    
    // MARK: - Actions -

    @IBAction func buttonPhotoAction(_ sender: UIButton) {
        viewModel?.presentPhotos()
    }
}
