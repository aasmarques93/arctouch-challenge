//
//  MovieViewCell.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class MovieViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    let viewModel = HomeViewModel.shared
    
    func setupView(at section: Int, row: Int) {
        viewModel.imageData(at: section, row: row) { (data) in
            if let data = data as? Data {
                self.imageView.image = UIImage(data: data)
            } else {
                self.imageView.image = nil
            }
        }
    }
}
