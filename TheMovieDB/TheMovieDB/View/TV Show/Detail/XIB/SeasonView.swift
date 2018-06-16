//
//  SeasonView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class SeasonView: XibView {
    // MARK: - Outlets -
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelEpisodeCount: UILabel!
    
    @IBOutlet weak var textViewOverview: UITextView!
}
