//
//  UserFriendDetailView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class UserFriendDetailView: UITableViewController {
    @IBOutlet weak var viewImageBackground: UIView!
    @IBOutlet weak var imageViewUserFriend: UIImageView!
    @IBOutlet weak var labelUserFriendName: UILabel!
    @IBOutlet weak var labelUserFriendEmail: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var viewModel: UserFriendViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBindings()
        viewModel?.loadData()
    }
    
    func setupBindings() {
        viewModel?.backgroundColor.bind(to: viewImageBackground.reactive.backgroundColor)
        viewModel?.picture.bind(to: imageViewUserFriend.reactive.image)
        viewModel?.name.bind(to: labelUserFriendName.reactive.text)
        viewModel?.email.bind(to: labelUserFriendEmail.reactive.text)
    }

    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
    
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(YourListViewCell.self, for: indexPath)
        cell.setSelectedView(backgroundColor: .clear)
//        cell.viewModel = viewModel?.yourListViewModel(at: indexPath)
        cell.setupView()
        return cell
    }
}
