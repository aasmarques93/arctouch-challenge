//
//  ProfileMainViewController.swift
//  Figurinhas
//
//  Created by Arthur Augusto Sousa Marques on 4/3/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

class ProfileMainView: UIViewController {
    @IBOutlet weak var containerLogin: UIView!
    @IBOutlet weak var containerProfile: UIView!
    @IBOutlet weak var buttonExit: UIButton!
    
    let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.profile.localized
        setupBindings()
    }
    
    func setupBindings() {
        viewModel.isLoginHidden.bind(to: containerLogin.reactive.isHidden)
        viewModel.isProfileHidden.bind(to: containerProfile.reactive.isHidden)
        viewModel.isButtonExitHidden.bind(to: buttonExit.reactive.isHidden)
    }
    
    @IBAction func buttonLogoutAction(_ sender: UIButton) {
        viewModel.logout()
    }
}
