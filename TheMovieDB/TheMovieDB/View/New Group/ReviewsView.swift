//
//  ReviewsView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ReviewCell"

class ReviewsView: UITableViewController {
    var viewModel: MovieDetailViewModel?
    
    var rowHeight: CGFloat = 100
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfReviews ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        cell.backgroundColor = indexPath.row % 2 == 0 ? HexColor.primary.color : HexColor.secondary.color.withAlphaComponent(0.1)
        
        if let labelAuthor = cell.viewWithTag(1) as? UILabel {
            labelAuthor.text = viewModel?.reviewAuthor(at: indexPath.row)
        }
        
        if let labelContent = cell.viewWithTag(2) as? UILabel {
            labelContent.text = viewModel?.reviewContent(at: indexPath.row)
        }
        
        return cell
    }
}
