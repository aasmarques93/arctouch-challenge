//
//  ReviewsView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class ReviewsView: UITableViewController {
    // MARK: - View Model -
    
    var viewModel: MovieDetailViewModel?
    
    // MARK: - Setup -
    
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
        let cell = tableView.dequeueReusableCell(ReviewViewCell.self, for: indexPath)
        cell.alternateBackground(at: indexPath, secondaryColor: HexColor.secondary.color.withAlphaComponent(0.1))
        cell.viewModel = viewModel
        cell.setupView(at: indexPath)
        return cell
    }
}
