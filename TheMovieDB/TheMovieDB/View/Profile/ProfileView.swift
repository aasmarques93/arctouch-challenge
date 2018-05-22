//
//  ProfileView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/18/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

class ProfileView: UITableViewController {
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var labelEmail: UILabel!
    
    @IBOutlet weak var viewPhoto: UIView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var viewModel: ProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        PhotoPicker.shared.photoPickerDelegate = self
        setupBindings()
    }
    
    func setupAppearance() {
        textFieldUsername.textColor = HexColor.text.color
        
        imageViewPhoto.image = imageViewPhoto.image?.withRenderingMode(.alwaysTemplate)
        imageViewPhoto.tintColor = HexColor.primary.color
    }
    
    func setupBindings() {
        viewModel?.username.bidirectionalBind(to: textFieldUsername.reactive.text)
        viewModel?.email.bind(to: labelEmail.reactive.text)
        viewModel?.picture.bind(to: imageViewPhoto.reactive.image)
        
    }
    
    @IBAction func buttonPhotoAction(_ sender: UIButton) {
        PhotoPicker.shared.present(in: self)
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @IBAction func buttonLogoutAction(_ sender: UIButton) {
        viewModel?.doLogout()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewHeaderTitleHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = labelHeader
        label.text = viewModel?.sectionTitle(at: section)
        return label
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard segmentedControl.selectedSegmentIndex != 0 else {
            return viewModel?.numberYourListSections ?? 0
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard segmentedControl.selectedSegmentIndex != 0 else {
            let cell = tableView.dequeueReusableCell(YourListViewCell.self, for: indexPath)
            cell.viewModel = viewModel?.yourListViewModel(at: indexPath)
            cell.setupView()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(FriendsViewCell.self, for: indexPath)
        return cell
    }
}

extension ProfileView: PhotoPickerDelegate {
    func dismissPhotoPicker(selectedImage: UIImage?, pathUrl: URL?) {
        guard let image = selectedImage, let data = image.getDataWithProportion(Double(imageViewPhoto.frame.width)) else {
            return
        }
        viewModel?.changeProfilePicture(data)
    }
}
