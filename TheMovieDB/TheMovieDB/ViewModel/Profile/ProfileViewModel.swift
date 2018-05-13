//
//  ProfileViewModel.swift
//  Figurinhas
//
//  Created by Rene X on 22/03/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import FBSDKLoginKit
import Bond

class ProfileViewModel: ViewModel {
    static let shared = ProfileViewModel()
    
    private var user: User {
        return Singleton.shared.user
    }
    
    weak var delegate: ViewModelDelegate?
    
    var username = Observable<String?>(nil)
    var email = Observable<String?>(nil)
    var phone = Observable<String?>(nil)
    var picture = Observable<UIImage?>(nil)
    var rating = Observable<String?>(nil)
    
    var isButtonExitHidden = Observable<Bool>(true)
    var isLoginHidden = Observable<Bool>(false)
    var isProfileHidden = Observable<Bool>(true)
    
    func loadData() {
        let isUserLogged = Singleton.shared.isUserLogged
        
        isLoginHidden.value = isUserLogged
        isProfileHidden.value = !isLoginHidden.value
        
        isButtonExitHidden.value = !isUserLogged
        
        username.value = user.name
        email.value = user.email
        phone.value = user.phone
        picture.value = Singleton.shared.userPhoto
        
        delegate?.reloadData?()
    }
    
    func updateUser() {
        let newUsername = username.value
        let newEmail = email.value
        let newPhone = phone.value
        if newUsername != user.name || newEmail != user.email || newPhone != user.phone {
            var newUser = Singleton.shared.user
            newUser.name = newUsername
            newUser.email = newEmail
            newUser.phone = newPhone
            Singleton.shared.saveUser()
        }
    }
    
    func changeProfilePicture(_ data:Data) {
        Singleton.shared.user.photo = UserDefaultsWrapper.getImagePath(with: data)
        Singleton.shared.saveUser()
    }
    
    func logout() {
        Singleton.shared.logout()
        loadData()
    }
}
