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
        viewModel.loadData()
    }
    
    func setupBindings() {
        viewModel.isLoginHidden.bind(to: containerLogin.reactive.isHidden)
        viewModel.isProfileHidden.bind(to: containerProfile.reactive.isHidden)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? ProfileView else {
            return
        }
        viewController.viewModel = viewModel
    }
}
