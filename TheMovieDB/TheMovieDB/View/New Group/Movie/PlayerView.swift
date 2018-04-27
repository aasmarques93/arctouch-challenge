//
//  YouTubePlayerView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import YouTubePlayer

class PlayerView: XibView {
    @IBOutlet weak var labelVideo: UILabel!
    @IBOutlet weak var playerView: YouTubePlayerView!
    
    override func awakeFromNib() {
        backgroundColor = HexColor.primary.color
        labelVideo.textColor = UIColor.white
        playerView.backgroundColor = UIColor.clear
    }
}
