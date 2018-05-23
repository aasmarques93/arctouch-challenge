//
//  ProfileMainView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

class ProfileMainView: UIViewController {
    @IBOutlet weak var containerLogin: UIView!
    @IBOutlet weak var containerProfile: UIView!
    
    let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.profile.localized
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func setupBindings() {
        viewModel.isLoginHidden.bind(to: containerLogin.reactive.isHidden)
        viewModel.isProfileHidden.bind(to: containerProfile.reactive.isHidden)
    }
    
    func loadData() {
        viewModel.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? LoginView {
            viewController.profileMainView = self
            return
        }
        if let viewController = segue.destination as? ProfileView {
            viewController.viewModel = viewModel
            return
        }
    }
}
