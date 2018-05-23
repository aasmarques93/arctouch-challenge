//
//  Singleton.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/8/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import FBSDKLoginKit

class Singleton {
    static let shared = Singleton()
    
    let serviceModel = ServiceModel()
    let profileServiceModel = ProfileServiceModel()
    
    var userPersonality: UserPersonality?
    var arrayUserWantToSeeMovies = [UserMovieShow]()
    var arrayUserShows = [UserMovieShow]()
    var arrayUserSeenMovies = [UserMovieShow]()
    
    let typingTimeInterval = 0.01
    var arrayPersonalityTypes = [PersonalityType]()
    
    var user = User.createEmptyUser() { didSet { saveUser() } }
    
    func updateUser(with object: User) {
        var newUser = user
        if let value = object.username { newUser.username = value }
        if let value = object.email { newUser.email = value }
        if let value = object.id { newUser.id = value }
        if let value = object.facebookId { newUser.facebookId = value }
        if let value = object.token { newUser.token = value }
        if let value = object.photo { newUser.photo = value }
        if let value = object.picture { newUser.picture = value }
        if let value = object.personality { newUser.personality = value }
        if let value = object.moviesWantToSeeList { newUser.moviesWantToSeeList = value }
        if let value = object.moviesSeenList { newUser.moviesSeenList = value }
        if let value = object.showsTrackList { newUser.showsTrackList = value }
        user = newUser
    }
    
    func saveUser() {
        UserDefaultsHelper.saveUserDefaults(object: user.dictionaryRepresentation(), key: .userLogged)
    }
    
    var userLogged: User? {
        guard let object = UserDefaultsHelper.fetchUserDefaults(key: .userLogged) else {
            return nil
        }
        return User(object: object)
    }
    
    var isUserLogged: Bool {
        return user.id != nil || user.email != nil
    }
    
    var userPhoto: UIImage? {
        guard let photo = user.photo, let data = UserDefaultsHelper.getImageData(from: photo) else {
            return nil
        }
        return UIImage(data: data)
    }
    
    func loadUserData(handler: HandlerObject? = nil) {
        profileServiceModel.getProfile { [weak self] (object) in
            guard let object = object as? User else {
                return
            }
            
            self?.userPersonality = object.personality
            self?.arrayUserWantToSeeMovies = object.moviesWantToSeeList ?? []
            self?.arrayUserShows = object.showsTrackList ?? []
            self?.arrayUserSeenMovies = object.moviesSeenList ?? []
            
            Singleton.shared.updateUser(with: object)
            handler?(object)
        }
    }
    
    func logout() {
        if let _ = FBSDKAccessToken.current() { FBSDKLoginManager().logOut() }
        user = User.createEmptyUser()
    }
    
    var userPersonalityType: PersonalityType? {
        guard let object = UserDefaultsHelper.fetchUserDefaults(key: .userPersonality) else {
            return nil
        }
        return PersonalityType(object: object)
    }
    
    var userAnsweredQuestions: [Answer] {
        guard let array = UserDefaultsHelper.fetchUserDefaults(key: .answeredQuestions) as? [[String: Any]] else {
            return [Answer]()
        }
        
        var arrayAnswers = [Answer]()
        
        array.forEach { (object) in
            arrayAnswers.append(Answer(object: object))
        }
        
        return arrayAnswers
    }
    
    func dictionaryAnswersCounts(at array: [Answer] = Singleton.shared.userAnsweredQuestions) -> [Int: Int] {
        var counts = [Int: Int]()
        
        array.forEach { (answer) in
            if let id = answer.personalityTypeId  {
                counts[id, default: 0] += 1
            }
        }
        
        return counts
    }
    
    var didSkipTestFromLauching = false
    var didSkipTest: Bool {
        guard let value = UserDefaultsHelper.fetchUserDefaults(key: .didSkipTest) as? Bool else {
            return false
        }
        return value
    }
    
    var isPersonalityTestAnswered: Bool {
        return userPersonalityType != nil
    }
    
    var arrayGenres = [Genres]()
    var arrayNetflixGenres = [Genres]()
    
    var isLanguagePortuguese: Bool {
        return Locale.preferredLanguages.first == "pt-BR"
    }
    
    func isMovieInYourWantToSeeList(movie: Movie) -> Bool {
        return arrayUserWantToSeeMovies.filter { $0.movieId == movie.id }.count > 0
    }
    
    func isMovieInYourSeenList(movie: Movie) -> Bool {
        return arrayUserSeenMovies.filter { $0.movieId == movie.id }.count > 0
    }
}
