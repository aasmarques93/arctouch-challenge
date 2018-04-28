//
//  StretchHeaderView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class StretchHeaderView: UIView {
    var imageViewHeader = UIImageView()
    var activityIndicator = UIActivityIndicatorView()
    
    var minHeightPercentual: CGFloat = 0, maxHeightPercentual: CGFloat = 1.3
    
    func setupHeaderView(tableView: UITableView, image: UIImage? = nil,
                         minHeightPercentual: CGFloat = 0, maxHeightPercentual: CGFloat = 1.3) {
        
        self.minHeightPercentual = minHeightPercentual
        self.maxHeightPercentual = maxHeightPercentual
        
        frame = CGRect(x: frame.minX, y: frame.height * -1, width: tableView.frame.width, height: frame.height)
        
        imageViewHeader.frame = frame
        imageViewHeader.contentMode = .scaleAspectFill
        imageViewHeader.clipsToBounds = true
        imageViewHeader.image = image
        imageViewHeader.removeFromSuperview()
        tableView.addSubview(imageViewHeader)
        
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = CGPoint(x: imageViewHeader.center.x, y: imageViewHeader.center.y - frame.height)
        activityIndicator.startAnimating()
        activityIndicator.removeFromSuperview()
        activityIndicator.isHidden = image != nil
        tableView.addSubview(activityIndicator)
        
        tableView.contentInset = UIEdgeInsetsMake(frame.height, 0, 0, 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = frame.height - (scrollView.contentOffset.y + frame.height)
        let newHeight = min(max(y, minHeightPercentual), frame.height * maxHeightPercentual)
        imageViewHeader.frame = CGRect(x: 0, y: scrollView.contentOffset.y, width: imageViewHeader.frame.width, height: newHeight)
    }
    
    func deviceOrientationDidRotate(to size: CGSize) {
        imageViewHeader.frame = CGRect(x: frame.minX, y: frame.minY, width: size.width, height: frame.height)
    }
}
