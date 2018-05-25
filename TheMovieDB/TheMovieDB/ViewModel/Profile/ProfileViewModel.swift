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
    // MARK: - Delegate -
    weak var delegate: ViewModelDelegate?
    
    // MARK: - Service Model -
    var serviceModel = ProfileServiceModel()
    
    // MARK: - Observables -
    var username = Observable<String?>(nil)
    var email = Observable<String?>(nil)
    var picture = Observable<UIImage>(#imageLiteral(resourceName: "empty-user"))
    
    var isButtonLogoutHidden = Observable<Bool>(true)
    var isLoginHidden = Observable<Bool>(false)
    var isProfileHidden = Observable<Bool>(true)
    
    // MARK: - Objects -
    private var user: User {
        return Singleton.shared.user
    }
    
    private var arrayYourListSections: [YourListSection] = [.wantToSeeMovies, .tvShowsTrack, .seenMovies]
    var numberYourListSections: Int { return arrayYourListSections.count }
    
    private var arrayUserFriends = [User]()
    var numberOfUserFriends: Int { return arrayUserFriends.count }
    
    // MARK: - Service requests -
    
    func loadData() {
        Singleton.shared.loadUserData()
        
        getUserFriends()
        
        let isUserLogged = Singleton.shared.isUserLogged
        
        isLoginHidden.value = isUserLogged
        isProfileHidden.value = !isUserLogged
        isButtonLogoutHidden.value = !isUserLogged
        
        username.value = user.username
        email.value = user.email
        picture.value = Singleton.shared.userPhoto ?? #imageLiteral(resourceName: "empty-user")
        
        delegate?.reloadData?()
    }
    
    // MARK: - User profile -
    
    func changeProfilePicture(_ data: Data) {
        Singleton.shared.user.photo = UserDefaultsHelper.getImagePath(with: data)
        Singleton.shared.saveUser()
    }
    
    func doLogout() {
        username.value = nil
        email.value = nil
        picture.value = #imageLiteral(resourceName: "empty-user")
        Loading.shared.start()
        serviceModel.doLogout { [weak self] (result) in
            Loading.shared.stop()
            Singleton.shared.logout()
            self?.loadData()
        }
    }
    
    // MARK: - Your list -
    
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
    
    func yourListViewModel(at indexPath: IndexPath) -> YourListViewModel? {
        return YourListViewModel(object: arrayYourListSections[indexPath.section])
    }
    
    // MARK: - User friends -
    
    func getUserFriends() {
        Facebook.shared.graphRequest(paths: [.friends], parameters: [.id, .name, .picture]) { [weak self] (connection, result, error) in
            if let error = error {
                print("Facebook User Friends Error: \(error)")
                return
            }
            
            print("Facebook User Friends Result: \(result ?? "")")
            guard let result = result as? [String: Any], let data = result["data"] as? [Any] else {
                return
            }
            
            self?.arrayUserFriends = [User]()
            data.forEach({ (object) in
                guard let result = object as? [String: Any] else {
                    return
                }
                var dictionary = result
                dictionary["facebookId"] = result["id"]
                dictionary["id"] = ""
                self?.arrayUserFriends.append(User(object: dictionary))
            })
            self?.delegate?.reloadData?()
        }
    }
    
    func userFriendViewModel(at indexPath: IndexPath) -> UserFriendViewModel {
        return UserFriendViewModel(object: arrayUserFriends[indexPath.row])
    }
}
