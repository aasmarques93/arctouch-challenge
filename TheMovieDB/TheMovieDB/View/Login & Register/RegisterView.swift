//
//  RegisterView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class RegisterView: UITableViewController {
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldPasswordConfirmation: UITextField!
    
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var buttonSignUp: UIButton!
    
    @IBOutlet weak var buttonUsernameInfo: UIButton!
    @IBOutlet weak var buttonEmailInfo: UIButton!
    @IBOutlet weak var buttonPasswordInfo: UIButton!
    @IBOutlet weak var buttonPasswordConfirmationInfo: UIButton!
    
    @IBOutlet weak var viewUsernameInfo: UIView!
    @IBOutlet weak var viewEmailInfo: UIView!
    @IBOutlet weak var viewPasswordInfo: UIView!
    @IBOutlet weak var viewPasswordConfirmationInfo: UIView!
    
    let viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupAppearance()
        setupBindings()
    }
    
    func setupAppearance() {
        textFieldUsername.textColor = HexColor.text.color
        textFieldUsername.placeHolderColor = HexColor.text.color
        textFieldEmail.textColor = HexColor.text.color
        textFieldEmail.placeHolderColor = HexColor.text.color
        textFieldPassword.textColor = HexColor.text.color
        textFieldPassword.placeHolderColor = HexColor.text.color
        textFieldPasswordConfirmation.textColor = HexColor.text.color
        textFieldPasswordConfirmation.placeHolderColor = HexColor.text.color
        
        buttonSignUp.backgroundColor = HexColor.secondary.color
    }
    
    func setupBindings() {
        viewModel.message.bind(to: labelMessage.reactive.text)
        
        viewModel.username.bidirectionalBind(to: textFieldUsername.reactive.text)
        viewModel.email.bidirectionalBind(to: textFieldEmail.reactive.text)
        viewModel.password.bidirectionalBind(to: textFieldPassword.reactive.text)
        viewModel.passwordConfirmation.bidirectionalBind(to: textFieldPasswordConfirmation.reactive.text)
        
        viewModel.usernameInfoImage.bind(to: buttonUsernameInfo.reactive.image)
        viewModel.emailInfoImage.bind(to: buttonEmailInfo.reactive.image)
        viewModel.passwordInfoImage.bind(to: buttonPasswordInfo.reactive.image)
        viewModel.passwordConfirmationInfoImage.bind(to: buttonPasswordConfirmationInfo.reactive.image)
        
        viewModel.colorUsernameInfo.bind(to: viewUsernameInfo.reactive.backgroundColor)
        viewModel.colorEmailInfo.bind(to: viewEmailInfo.reactive.backgroundColor)
        viewModel.colorPasswordInfo.bind(to: viewPasswordInfo.reactive.backgroundColor)
        viewModel.colorPasswordConfirmationInfo.bind(to: viewPasswordConfirmationInfo.reactive.backgroundColor)
        
        viewModel.colorUsernameInfo.bind(to: buttonUsernameInfo.reactive.tintColor)
        viewModel.colorEmailInfo.bind(to: buttonEmailInfo.reactive.tintColor)
        viewModel.colorPasswordInfo.bind(to: buttonPasswordInfo.reactive.tintColor)
        viewModel.colorPasswordConfirmationInfo.bind(to: buttonPasswordConfirmationInfo.reactive.tintColor)
    }
    
    @IBAction func buttonLoginAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSignUpAction(_ sender: UIButton) {
        viewModel.doSignUp()
    }
}

extension RegisterView: ViewModelDelegate {
    func reloadData() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(message: String?) {
        alertController?.show(message: message)
    }
}
