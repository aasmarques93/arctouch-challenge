//
//  LoginViewModel.swift
//  Figurinhas
//
//  Created by Arthur Augusto Sousa Marques on 3/22/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

protocol LoginViewModelDelegate: class {
    func didLogin()
    func showError(message: String)
    func sendPasswordReset()
}

fileprivate enum FormValidationItem {
    case email
    case password
}

class LoginViewModel: ViewModel {
    weak var delegate: LoginViewModelDelegate?
    
    private let serviceModel = LoginServiceModel()
    
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
            delegate?.showError(message: Messages.invalidEmail.rawValue)
            return false
        }
        if !isPasswordValid {
            delegate?.showError(message: Messages.invalidPassword.rawValue)
            return false
        }
        return true
    }
    
    func loadData() {
        
    }
    
    private func getUserLogged() {
        if let userLogged = Singleton.shared.userLogged {
            Singleton.shared.user = userLogged
//            ServiceModel().setConnectionHeader(token: user.token)
        }
    }
    
    func setupFacebookDataIfNeeded() {
        if let _ = FBSDKAccessToken.current() {
            Loading.shared.start()
            setFacebookId(handlerResult: { [weak self] _ in
                Loading.shared.stop()
                self?.delegate?.didLogin()
            })
        }
    }
        
    func setFacebookId(handlerResult: @escaping HandlerObject) {
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
            
            Singleton.shared.user = User(object: result)
            
            self?.signUpFacebookUser()
            self?.downloadUserPhoto(handlerData: { (data) in
                guard let data = data as? Data else {
                    return
                }
                
                Singleton.shared.user.photo = UserDefaultsHelper.getImagePath(with: data)
                Singleton.shared.saveUser()
            })
        }
    }
    
    private func signUpFacebookUser() {
        guard user.token == nil else {
            return
        }
        
        Loading.shared.start()
        RegisterServiceModel().signup(username: user.name,
                                      email: user.email,
                                      facebookId: user.facebookId,
                                      handlerObject: { [weak self] (object) in
        
                                        Loading.shared.stop()
                                        guard let user = object as? User else {
                                            return
                                        }
                                        
                                        print("Facebook user signed up")
                                        Singleton.shared.user.token = user.token
                                        Singleton.shared.saveUser()
                                        self?.delegate?.didLogin()
        }) { [weak self] (error) in
            print("Error signing up facebook user: \(error ?? "")")
            
            self?.serviceModel.authenticate(facebookId: self?.user.facebookId, handlerObject: { [weak self] (object) in
                Loading.shared.stop()
                
                guard let user = object as? User else {
                    return
                }

                print("Facebook user authenticated")
                Singleton.shared.user.token = user.token
                Singleton.shared.saveUser()
                self?.delegate?.didLogin()
            }) { (error) in
                Loading.shared.stop()
                print("Error authenticating facebook user: \(error ?? "")")
            }
        }
    }
    
    private func downloadUserPhoto(handlerData: @escaping HandlerObject) {
        serviceModel.loadImage(path: user.picture?.data?.url) { (data) in
            handlerData(data)
        }
    }
    
    func downloadImage(url: URL, handlerResult: @escaping HandlerObject) {
        serviceModel.getDataFromUrl(url: url) { data, response, error in
            handlerResult(nil)
            
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async() {
                Singleton.shared.user.photo = UserDefaultsHelper.getImagePath(with: data)
            }
        }
    }
    
    func doLogin() {
        guard isFormValid else {
            return
        }
        
        Loading.shared.start()
        serviceModel.authenticate(email: email.value, password: password.value, handlerObject: { [weak self] (object) in
            Loading.shared.stop()
            
            guard let user = object as? User else {
                return
            }
            
            Singleton.shared.user = user
            self?.delegate?.didLogin()
        }) { [weak self] (error) in
            Loading.shared.stop()
            
            guard let error = error as? String else {
                return
            }
            
            self?.delegate?.showError(message: error)
        }
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
//            if let error = error as? Error { self.delegate?.showError(message: error.localizedDescription) }
//        }
    }
}
