//
//  LoginView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond
import FBSDKLoginKit

class LoginView: UITableViewController {
    @IBOutlet weak var buttonFacebookLogin: FBSDKLoginButton!
    
    @IBOutlet var viewHeader: UIView!
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var buttonEmailInfo: UIButton!
    @IBOutlet weak var buttonPasswordInfo: UIButton!
    
    @IBOutlet weak var viewEmailInfo: UIView!
    @IBOutlet weak var viewPasswordInfo: UIView!
    
    @IBOutlet weak var buttonLogin: UIButton!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupFacebook()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.delegate = self
        viewModel.setupFacebookDataIfNeeded()
    }
    
    func setupAppearance() {
        textFieldEmail.textColor = HexColor.text.color
        textFieldEmail.placeHolderColor = HexColor.text.color
        textFieldPassword.textColor = HexColor.text.color
        textFieldPassword.placeHolderColor = HexColor.text.color
        
        buttonLogin.backgroundColor = HexColor.secondary.color
    }
    
    func setupFacebook() {
        buttonFacebookLogin.readPermissions = Facebook.shared.readPermissions
    }
    
    func setupBindings() {
        viewModel.email.bidirectionalBind(to: textFieldEmail.reactive.text)
        viewModel.password.bidirectionalBind(to: textFieldPassword.reactive.text)
        
        viewModel.emailInfoImage.bind(to: buttonEmailInfo.reactive.image)
        viewModel.passwordInfoImage.bind(to: buttonPasswordInfo.reactive.image)
        
        viewModel.colorEmailInfo.bind(to: viewEmailInfo.reactive.backgroundColor)
        viewModel.colorPasswordInfo.bind(to: viewPasswordInfo.reactive.backgroundColor)
        
        viewModel.colorEmailInfo.bind(to: buttonEmailInfo.reactive.tintColor)
        viewModel.colorPasswordInfo.bind(to: buttonPasswordInfo.reactive.tintColor)
    }
    
    @IBAction func buttonLoginAction(_ sender: Any) {
        viewModel.doLogin()
    }
}

extension LoginView: LoginViewModelDelegate {
    func didLogin() {
        view.endEditing(true)
//        ProfileViewModel.shared.setupContent()
    }
    
    func showAlert(message: String?) {
        view.endEditing(true)
        alertController?.show(message: message)
    }
    
    func sendPasswordReset() {
        view.endEditing(true)
        alertController?.show(message: Messages.resetPassword.localized)
    }
}

