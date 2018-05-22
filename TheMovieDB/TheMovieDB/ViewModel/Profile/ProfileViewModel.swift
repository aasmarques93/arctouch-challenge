//
//  ProfileViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import FBSDKLoginKit
import Bond

enum YourListSection: Int {
    case wantToSeeMovies = 0
    case tvShowsTrack = 1
    case seenMovies = 2
    
    var description: String {
        switch self {
        case .wantToSeeMovies:
            return "Your Want-To-See Movies"
        case .tvShowsTrack:
            return "TV You Track"
        case .seenMovies:
            return "Your Seen Movies"
        }
    }
    
    var localized: String {
        return NSLocalizedString(self.description, comment: "")
    }
}

class ProfileViewModel: ViewModel {
    static let shared = ProfileViewModel()
    
    private var user: User {
        return Singleton.shared.user
    }
    
    weak var delegate: ViewModelDelegate?
    
    var username = Observable<String?>(nil)
    var email = Observable<String?>(nil)
    var picture = Observable<UIImage?>(nil)
    var rating = Observable<String?>(nil)
    
    var isButtonLogoutHidden = Observable<Bool>(true)
    var isLoginHidden = Observable<Bool>(false)
    var isProfileHidden = Observable<Bool>(true)
    
    private var arrayYourListSections: [YourListSection] = [.wantToSeeMovies, .tvShowsTrack, .seenMovies]
    var numberYourListSections: Int { return arrayYourListSections.count }
    
    func loadData() {
        let isUserLogged = Singleton.shared.isUserLogged
        
        isLoginHidden.value = isUserLogged
        isProfileHidden.value = !isUserLogged
        isButtonLogoutHidden.value = !isUserLogged
        
        username.value = user.username
        email.value = user.email
        picture.value = Singleton.shared.userPhoto
        
        delegate?.reloadData?()
    }
    
    private func updateUser() {
        let newUsername = username.value
        let newEmail = email.value
        if newUsername != user.username || newEmail != user.email {
            var newUser = Singleton.shared.user
            newUser.username = newUsername
            newUser.email = newEmail
            Singleton.shared.saveUser()
        }
    }
    
    func changeProfilePicture(_ data: Data) {
        Singleton.shared.user.photo = UserDefaultsHelper.getImagePath(with: data)
        Singleton.shared.saveUser()
    }
    
    func doLogout() {
        Singleton.shared.logout()
        loadData()
    }
    
    func sectionTitle(at section: Int) -> String? {
        return arrayYourListSections[section].localized
    }
    
    func isMovieShowEmpty(at indexPath: IndexPath) -> Bool {
        let yourListSection = arrayYourListSections[indexPath.section]
        
        switch yourListSection {
        case .wantToSeeMovies:
            return Singleton.shared.arrayUserWantToSeeMovies.count == 0
        case .tvShowsTrack:
            return Singleton.shared.arrayUserShows.count == 0
        case .seenMovies:
            return Singleton.shared.arrayUserSeenMovies.count == 0
        }
    }
    
    // MARK: - Your List -
    
    func yourListViewModel(at indexPath: IndexPath) -> YourListViewModel? {
        return YourListViewModel(object: arrayYourListSections[indexPath.section])
    }
}
