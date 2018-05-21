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
    let yourListServiceModel = YourListServiceModel()
    
    var arrayUserWantToSeeMovies = [UserMovie]()
    var arrayUserSeenMovies = [UserMovie]()
    
    let typingTimeInterval = 0.01
    var arrayPersonalityTypes = [PersonalityType]()
    
    var user = User.createEmptyUser() {
        didSet {
            saveUser()
            loadUserData()
        }
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
    
    func loadUserData() {
        getUserWantToSeeMovies()
        getUserSeenMovies()
    }
    
    func getUserWantToSeeMovies(handler: HandlerObject? = nil) {
        yourListServiceModel.getUserMovies(requestUrl: .userWantToSeeMovies) { [weak self] (object) in
            guard let array = object as? [UserMovie] else {
                return
            }
            self?.arrayUserWantToSeeMovies = array
            handler?(array)
        }
    }
    
    func getUserSeenMovies(handler: HandlerObject? = nil) {
        yourListServiceModel.getUserMovies(requestUrl: .userSeenMovies) { [weak self] (object) in
            guard let array = object as? [UserMovie] else {
                return
            }
            self?.arrayUserSeenMovies = array
            handler?(array)
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
