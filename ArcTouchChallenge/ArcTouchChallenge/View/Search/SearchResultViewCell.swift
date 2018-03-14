//
//  SearchResultViewCell.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class SearchResultViewCell: UITableViewCell {
    @IBOutlet weak var imageViewMovie: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    let viewModel = SearchViewModel.shared
    
    func setupView(at indexPath: IndexPath) {
        if let value = viewModel.movieName(at: indexPath) { labelName.text = value }
        
        viewModel.imageData(at: indexPath) { (data) in
            if let data = data as? Data {
                self.imageViewMovie.image = UIImage(data: data)
            }
        }
    }
}
