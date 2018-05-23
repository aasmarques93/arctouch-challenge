//
//  FriendsViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/19/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class FriendsViewCell: UITableViewCell {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imageViewUserFriend: UIImageView!
    @IBOutlet weak var labelUserFriendName: UILabel!
    @IBOutlet weak var labelUserFriendPersonality: UILabel!
    @IBOutlet weak var labelUserFriendMovieShow: UILabel!
    
    var viewModel: UserFriendViewModel?
    
    func setupView() {
        viewModel?.backgroundColor.bind(to: viewBackground.reactive.backgroundColor)
        viewModel?.picture.bind(to: imageViewUserFriend.reactive.image)
        viewModel?.name.bind(to: labelUserFriendName.reactive.text)
        viewModel?.personality.bind(to: labelUserFriendPersonality.reactive.text)
        viewModel?.movieShow.bind(to: labelUserFriendMovieShow.reactive.text)
        
        viewModel?.loadData()
    }
}
