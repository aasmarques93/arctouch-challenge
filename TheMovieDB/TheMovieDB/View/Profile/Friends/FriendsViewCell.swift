//
//  FriendsViewCell.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/19/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class FriendsViewCell: UITableViewCell {
    // MARK: - Outlets -
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imageViewUserFriend: UIImageView!
    @IBOutlet weak var labelUserFriendName: UILabel!
    @IBOutlet weak var labelUserFriendPersonality: UILabel!
    @IBOutlet weak var labelUserFriendMovieShow: UILabel!
    
    // MARK: - View Model -
    
    var viewModel: UserFriendViewModel?
    
    // MARK: - Setup -
    
    func setupView() {
        imageViewUserFriend.sd_setImage(with: viewModel?.imageUrl, placeholderImage: #imageLiteral(resourceName: "empty-user"))
        
        viewModel?.name.bind(to: labelUserFriendName.reactive.text)
        viewModel?.personality.bind(to: labelUserFriendPersonality.reactive.text)
        viewModel?.movieShow.bind(to: labelUserFriendMovieShow.reactive.text)
        
        viewModel?.loadData()
    }
}
