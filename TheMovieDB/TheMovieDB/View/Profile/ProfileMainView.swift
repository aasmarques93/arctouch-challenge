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
    // MARK: - Outlets -
    
    @IBOutlet weak var containerLogin: UIView!
    @IBOutlet weak var containerProfile: UIView!
    
    // MARK: - View Model -
    
    private let viewModel = ProfileViewModel()
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.profile.localized
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Bindings -
    
    private func setupBindings() {
        viewModel.isLoginHidden.bind(to: containerLogin.reactive.isHidden)
        viewModel.isProfileHidden.bind(to: containerProfile.reactive.isHidden)
    }
    
    // MARK: - Methods -
    
    func loadData() {
        viewModel.loadData()
    }
    
    // MARK: - Segue -
    
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
