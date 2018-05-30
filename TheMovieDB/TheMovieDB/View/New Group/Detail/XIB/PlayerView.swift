//
//  YouTubePlayerView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class PlayerView: XibView {
    // MARK: - Outlets -
    
    @IBOutlet weak var labelVideo: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
}
