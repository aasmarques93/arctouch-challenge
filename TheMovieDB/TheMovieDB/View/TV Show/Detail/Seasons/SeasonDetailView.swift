//
//  SeasonDetailView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/30/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class SeasonDetailView: UITableViewController {
    // MARK: - Outlets -
    
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var textViewSeasonOverview: UITextView!
    
    // MARK: - View Model -
    
    var viewModel: SeasonDetailViewModel?
    
    // MARK: - Life cycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = viewModel?.seasonName
        setupBindings()
        viewModel?.delegate = self
        viewModel?.loadData()
    }
    
    // MARK: - View model bindings -
    
    private func setupBindings() {
        viewModel?.overview.bind(to: textViewSeasonOverview.reactive.text)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfEpisodes ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(EpisodeViewCell.self, for: indexPath)
        cell.setSelectedView(backgroundColor: UIColor.clear)
        cell.viewModel = viewModel?.episodeViewModel(at: indexPath)
        cell.setupView()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = viewModel?.heightForEpisodeOverview(at: indexPath) {
            return super.tableView(tableView, heightForRowAt: indexPath) + height
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}

extension SeasonDetailView: ViewModelDelegate {
    
    // MARK: - View model delegate -
    
    func reloadData() {
        if let height = viewModel?.heightForOverview {
            viewHeader.frame = CGRect(x: viewHeader.frame.minX,
                                      y: viewHeader.frame.minY,
                                      width: viewHeader.frame.width,
                                      height: height)
        }
        
        tableView.reloadData()
    }
}

