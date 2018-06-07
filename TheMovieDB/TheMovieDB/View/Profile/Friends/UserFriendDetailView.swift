//
//  UserFriendDetailView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class UserFriendDetailView: UITableViewController {
    // MARK: - Outlets -
    
    @IBOutlet weak var viewImageBackground: UIView!
    @IBOutlet weak var imageViewUserFriend: UIImageView!
    @IBOutlet weak var labelUserFriendName: UILabel!
    @IBOutlet weak var labelUserFriendEmail: UILabel!
    
    @IBOutlet weak var containerPersonalityTestResult: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Properties -
    
    var personalityTestResultDetailsView: PersonalityTestResultDetailsView?

    // MARK: - View Model -

    var viewModel: UserFriendViewModel?
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.delegate = self
        viewModel?.loadData()
        setupBindings()
        setupFooterView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        GoogleAdsHelper.shared.showInterstitial()
    }
    
    // MARK: - Appearance -
    
    func setupAppearance() {
        containerPersonalityTestResult.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
    }
    
    func setupFooterView() {
        tableView.tableFooterView = segmentedControl.selectedSegmentIndex == 0 ? containerPersonalityTestResult : nil
    }
    
    // MARK: - Bindings -
    
    func setupBindings() {
        imageViewUserFriend.sd_setImage(with: viewModel?.imageUrl, placeholderImage: #imageLiteral(resourceName: "empty-user"))
        viewModel?.name.bind(to: labelUserFriendName.reactive.text)
        viewModel?.email.bind(to: labelUserFriendEmail.reactive.text)
    }
    
    // MARK: - Personality Test -
    
    func setupPersonalityTestResultViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        personalityTestResultDetailsView?.viewModel = viewModel.personalityTestResultViewModel()
        personalityTestResultDetailsView?.setupBindings()
        personalityTestResultDetailsView?.setupData(animated: true)
    }
    
    // MARK: - Actions -
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        setupFooterView()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source -

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewHeaderTitleHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = labelHeader
        label.text = viewModel?.sectionTitle(at: section)
        return label
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard segmentedControl.selectedSegmentIndex > 0 else {
            return 0
        }
        return viewModel?.numberYourListSections ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(YourListViewCell.self, for: indexPath)
        cell.setSelectedView(backgroundColor: .clear)
        cell.viewModel = viewModel?.yourListViewModel(at: indexPath)
        cell.setupView()
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else {
            return
        }
        
        self.title = scrollView.contentOffset.y > labelUserFriendName.frame.maxY ? viewModel?.name.value : ""
    }
    
    // MARK: - Segue -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? PersonalityTestResultDetailsView else {
            return
        }
        personalityTestResultDetailsView = viewController
    }
}

extension UserFriendDetailView: ViewModelDelegate {
    
    // MARK: - ViewModelDelegate -
    
    func reloadData() {
        setupPersonalityTestResultViewModel()
    }
}
