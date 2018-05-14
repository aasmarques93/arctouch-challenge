//
//  MoviePreviewView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class MoviePreviewView: XibView {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackground.borderWidth = 2.0
        viewBackground.borderColor = HexColor.secondary.color
        backgroundColor = HexColor.primary.color
        imageView.backgroundColor = HexColor.primary.color
    }
}
