//
//  MovieView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class MovieView: XibView {
    @IBOutlet weak var imageViewMovie: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = HexColor.primary.color
        imageViewMovie.backgroundColor = HexColor.primary.color
    }
}
