//
//  TrackView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/21/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class TrackView: UITableViewController {
    var viewModel: TrackViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.trackTvShow.localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.delegate = self
        viewModel?.loadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSeasons ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = labelHeader
        label.text = viewModel?.sectionTitle(at: section)
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TrackViewCell.self, for: indexPath)
        cell.viewModel = viewModel
        cell.setupView(at: indexPath)
        return cell
    }
}

extension TrackView: TrackViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadData(at index: Int) {
        let indexPath = IndexPath(row: 0, section: index)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
