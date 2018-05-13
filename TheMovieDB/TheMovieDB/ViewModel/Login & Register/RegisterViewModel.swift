//
//  RegisterViewModel.swift
//  Figurinhas
//
//  Created by Arthur Augusto Sousa Marques on 4/3/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

protocol RegisterViewModelDelegate: class {
    func didSignUp()
    func showError(message: String)
}

fileprivate enum FormValidationItem {
    case username
    case email
    case password
    case passwordConfirmation
}

class RegisterViewModel: ViewModel {
    weak var delegate: RegisterViewModelDelegate?
    
    var message = Observable<String?>(nil)
    
    var username = Observable<String?>(nil)
    var email = Observable<String?>(nil)
    var password = Observable<String?>(nil)
    var passwordConfirmation = Observable<String?>(nil)
    
    var usernameInfoImage = Observable<UIImage>(#imageLiteral(resourceName: "user"))
    var emailInfoImage = Observable<UIImage>(#imageLiteral(resourceName: "email"))
    var passwordInfoImage = Observable<UIImage>(#imageLiteral(resourceName: "password"))
    var passwordConfirmationInfoImage = Observable<UIImage>(#imageLiteral(resourceName: "password"))
    
    var colorUsernameInfo = Observable<UIColor>(HexColor.text.color)
    var colorEmailInfo = Observable<UIColor>(HexColor.text.color)
    var colorPasswordInfo = Observable<UIColor>(HexColor.text.color)
    var colorPasswordConfirmationInfo = Observable<UIColor>(HexColor.text.color)
    
    private let serviceModel = RegisterServiceModel()
    
    private let defaultMessage = Messages.userRegisterMessage.rawValue
    
    private var isEmailValid: Bool {
        return valueDescription(email.value).isEmail
    }
    
    private var isPasswordValid: Bool {
        return valueDescription(password.value).isPasswordValid(minimumDigits: 6, isComplexPasswordRequired: false)
    }
    
    private var isPasswordConfirmationValid: Bool {
        return password.value == passwordConfirmation.value
    }
    
    init() {
        message.value = defaultMessage

        validate(username, item: .username, observableImage: usernameInfoImage, observableColor: colorUsernameInfo, sucessImage: #imageLiteral(resourceName: "user"))
        validate(email, item: .email, observableImage: emailInfoImage, observableColor: colorEmailInfo, sucessImage: #imageLiteral(resourceName: "email"))
        validate(password, item: .password, observableImage: passwordInfoImage, observableColor: colorPasswordInfo, sucessImage: #imageLiteral(resourceName: "password"))
        validate(passwordConfirmation,
                 item: .passwordConfirmation,
                 observableImage: passwordConfirmationInfoImage,
                 observableColor: colorPasswordConfirmationInfo,
                 sucessImage: #imageLiteral(resourceName: "password"))
    }
    
    private func validate(_ observable: Observable<String?>,
                          item: FormValidationItem,
                          observableImage: Observable<UIImage>,
                          observableColor: Observable<UIColor>,
                          errorImage: UIImage = #imageLiteral(resourceName: "alert"),
                          sucessImage: UIImage) {
        
        _ = observable.observeNext(with: { [weak self] (string) in
            guard let string = string, !string.isEmptyOrWhitespace else {
                return
            }
            
            observableImage.value = errorImage
            observableColor.value = HexColor.accent.color
            
            guard let isValid = self?.isObservableValid(observable, item: item), isValid else {
                return
            }
            
            observableImage.value = sucessImage
            observableColor.value = HexColor.text.color
        })
    }
    
    private func isObservableValid(_ observable: Observable<String?>, item: FormValidationItem) -> Bool {
        switch item {
        case .username:
            guard let isEmptyOrWhitespace = observable.value?.isEmptyOrWhitespace else {
                return false
            }
            return !isEmptyOrWhitespace
        case .email:
            guard isEmailValid else {
                return false
            }
            return true
        case .password:
            guard isPasswordValid else {
                return false
            }
            return true
        case .passwordConfirmation:
            guard isPasswordConfirmationValid else {
                return false
            }
            return true
        }
    }
    
    var isFormValid: Bool {
        if valueDescription(username.value).isEmptyOrWhitespace {
            delegate?.showError(message: Messages.invalidUser.rawValue)
            return false
        }
        if !isEmailValid {
            delegate?.showError(message: Messages.invalidEmail.rawValue)
            return false
        }
        if !isPasswordValid {
            delegate?.showError(message: Messages.invalidPassword.rawValue)
            return false
        }
        if !isPasswordConfirmationValid {
            delegate?.showError(message: Messages.invalidPasswordConfirmation.rawValue)
            return false
        }
        return true
    }
    
    func loadData() {
        
    }
    
    func doSignUp() {
        guard isFormValid else {
            return
        }
        
        Loading.shared.start()
        serviceModel.signup(username: username.value, email: email.value, password: password.value, handlerObject: { [weak self] (object) in
            Loading.shared.stop()
            
            guard let user = object as? User else {
                return
            }
            Singleton.shared.user = user
            Singleton.shared.user.token = user.token
            Singleton.shared.saveUser()
            self?.delegate?.didSignUp()
        }) { [weak self] (error) in
            Loading.shared.stop()
            guard let error = error as? String else {
                return
            }
            self?.delegate?.showError(message: error)
        }
    }
}

