//
//  LoginViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

protocol LoginViewModelDelegate: ViewModelDelegate {
    func didLogin()
    func sendPasswordReset()
}

fileprivate enum FormValidationItem {
    case email
    case password
}

class LoginViewModel: ViewModel {
    weak var delegate: LoginViewModelDelegate?
    
    private let serviceModel = LoginServiceModel()
    private lazy var registerServiceModel = RegisterServiceModel()
    
    var email = Observable<String?>(nil)
    var password = Observable<String?>(nil)

    var emailInfoImage = Observable<UIImage>(#imageLiteral(resourceName: "email"))
    var passwordInfoImage = Observable<UIImage>(#imageLiteral(resourceName: "password"))
    
    var colorEmailInfo = Observable<UIColor>(HexColor.text.color)
    var colorPasswordInfo = Observable<UIColor>(HexColor.text.color)
    
    private var user: User {
        return Singleton.shared.user
    }
    
    var isUserLogged: Bool { return user.id != nil || user.email != nil }
    
    private var isEmailValid: Bool {
        return valueDescription(email.value).isEmail
    }
    
    private var isPasswordValid: Bool {
        return valueDescription(password.value).isPasswordValid(minimumDigits: 6, isComplexPasswordRequired: false)
    }
    
    init() {
        getUserLogged()
        
        validate(email, item: .email, observableImage: emailInfoImage, observableColor: colorEmailInfo, sucessImage: #imageLiteral(resourceName: "email"))
        validate(password, item: .password, observableImage: passwordInfoImage, observableColor: colorPasswordInfo, sucessImage: #imageLiteral(resourceName: "password"))
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
        }
    }
    
    var isFormValid: Bool {
        if !isEmailValid {
            delegate?.showAlert?(message: Messages.invalidEmail.rawValue)
            return false
        }
        if !isPasswordValid {
            delegate?.showAlert?(message: Messages.invalidPassword.rawValue)
            return false
        }
        return true
    }
    
    func loadData() {
        
    }
    
    private func getUserLogged() {
        if let userLogged = Singleton.shared.userLogged {
            serviceModel.authenticate(userId: userLogged.id) { (object) in
                Singleton.shared.updateUser(with: userLogged)
            }
        }
    }
    
    func setupFacebookDataIfNeeded() {
        if let _ = FBSDKAccessToken.current() {
            setFacebookId(handlerResult: { [weak self] _ in
                self?.delegate?.didLogin()
            })
        }
    }
        
    func setFacebookId(handlerResult: @escaping HandlerObject) {
        guard !Singleton.shared.isUserLogged else {
            return
        }
        
        Facebook.shared.graphRequest(paths: [.me]) { [weak self] (connection, result, error) in
            handlerResult(nil)
            
            if let error = error {
                print("Facebook Error: \(error)")
                return
            }
            
            print("Facebook Result: \(result ?? "")")
            guard let result = result as? [String: Any] else {
                return
            }
            
            var dictionary = result
            dictionary["facebookId"] = result["id"]
            dictionary["id"] = ""
            Singleton.shared.updateUser(with: User(object: dictionary))
            
            self?.downloadUserPhoto()
            self?.signUpFacebookUser()
        }
    }
    
    private func signUpFacebookUser() {
        registerServiceModel.signup(username: user.username,
                                    email: user.email,
                                    name: user.name,
                                    facebookId: user.facebookId,
                                    handler: { [weak self] (object) in
        
                                        guard let user = object as? User else {
                                            return
                                        }
                                        
                                        do {
                                            try self?.showError(with: user)
                                        } catch {
                                            self?.authenticateFacebookUser()
                                            return
                                        }
                                        
                                        print("Facebook user signed up")
                                        Singleton.shared.updateUser(with: user)
                                        self?.delegate?.didLogin()
        })
    }
    
    private func authenticateFacebookUser() {
        serviceModel.authenticate(email: user.email, facebookId: user.facebookId, handler: { [weak self] (object) in
            guard let user = object as? User else {
                return
            }
            
            do {
                try self?.showError(with: user)
            } catch {
                if let error = error as? Error {
                    self?.delegate?.showAlert?(message: error.message)
                }
                return
            }
            
            Singleton.shared.updateUser(with: user)
            self?.delegate?.didLogin()
        })
    }
    
    private func downloadUserPhoto() {
        serviceModel.loadImage(path: user.picture?.data?.url) { (data) in
            guard let data = data as? Data else {
                return
            }
            
            Singleton.shared.user.photo = UserDefaultsHelper.getImagePath(with: data)
            Singleton.shared.saveUser()
        }
    }
    
    func doLogin() {
        guard isFormValid else {
            return
        }
        
        Loading.shared.start()
        serviceModel.authenticate(email: email.value, password: password.value, handler: { [weak self] (object) in
            Loading.shared.stop()
            
            guard let user = object as? User else {
                return
            }
            
            do {
                try self?.showError(with: user)
            } catch {
                if let error = error as? Error {
                    self?.delegate?.showAlert?(message: error.message)
                }
                return
            }
            
            Singleton.shared.updateUser(with: user)
            self?.delegate?.didLogin()
        })
    }
    
    func logout() {
        email.value = nil
        password.value = nil
        
        Singleton.shared.logout()
    }
    
    func recoverPassword() {        
//        serviceModel.recoverPassword(email: email, handlerObject: { (object) in
//            self.delegate?.sendPasswordReset()
//        }) { (error) in
//            if let error = error as? Error { self.delegate?.showAlert(message: error.localizedDescription) }
//        }
    }
}
