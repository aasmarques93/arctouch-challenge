//
//  Singleton.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/8/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import FBSDKLoginKit

class Singleton {
    
    // MARK: - Singleton -
    
    static let shared = Singleton()
    
    // MARK: - Service Model -

    let serviceModel = GenericServiceModel()
    let profileServiceModel = ProfileServiceModel()
    let personalityTestServiceModel = PersonalityTestServiceModel()
    
    // MARK: - User -
    
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
        UserDefaultsHelper.save(object: user.dictionaryRepresentation(), key: .userLogged)
    }
    
    var userLogged: User? {
        guard let object = UserDefaultsHelper.fetch(key: .userLogged) else {
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
    
    // MARK: - User Personality -
    
    var userPersonality: UserPersonality? {
        didSet {
            let personalityTypes = arrayPersonalityTypes.filter { $0.id == userPersonality?.personalityTypeId }
            savePersonalityType(personalityTypes.first)
        }
    }
    
    var arrayPersonalityTypes = [PersonalityType]()
    var arrayPersonalityQuestions = [Questions]()
    
    // MARK: - User Profile -
    
    var arrayUserWantToSeeMovies = [UserMovieShow]()
    var arrayUserShows = [UserMovieShow]()
    var arrayUserSeenMovies = [UserMovieShow]()
    var arrayUserRatings = [UserRating]()
    var arrayUserFriends = [User]()
    
    // MARK: - Service requests -
    
    func loadUserData(handler: HandlerCallback? = nil) {
        profileServiceModel.getProfile { [weak self] (object) in
            self?.userPersonality = object.personality
            self?.arrayUserWantToSeeMovies = object.moviesWantToSeeList ?? []
            self?.arrayUserShows = object.showsTrackList ?? []
            self?.arrayUserSeenMovies = object.moviesSeenList ?? []
            self?.arrayUserRatings = object.ratings ?? []
            
            self?.savePersonalityTestIfNeeded()
            self?.updateUser(with: object)
            handler?()
        }
    }
    
    func logout() {
        if let _ = FBSDKAccessToken.current() { FBSDKLoginManager().logOut() }
        user = User.createEmptyUser()
        UserDefaultsHelper.delete(key: .userPersonality)
    }

    // MARK: - Saving personality test -
    
    func saveUserPersonalityTest(dictionaryAnswersCounts: [Int: Int], personalityType: PersonalityType) {
        var comedyPercentage: Float = 0
        var actionPercentage: Float = 0
        var dramaPercentage: Float = 0
        var thrillerPercentage: Float = 0
        var documentaryPercentage: Float = 0
        
        dictionaryAnswersCounts.forEach { (key, value) in
            arrayPersonalityTypes.forEach({ (personality) in
                guard key == personality.id else {
                    return
                }
                
                let totalAnswers = 10
                let percentage = Float(value) / Float(totalAnswers) * 100
                if personality.title == Titles.comedy.rawValue { comedyPercentage = percentage }
                if personality.title == Titles.action.rawValue { actionPercentage = percentage }
                if personality.title == Titles.drama.rawValue { dramaPercentage = percentage }
                if personality.title == Titles.thriller.rawValue { thrillerPercentage = percentage }
                if personality.title == Titles.documentary.rawValue { documentaryPercentage = percentage }
            })
        }
        
        if comedyPercentage == 0
            && actionPercentage == 0
            && dramaPercentage == 0
            && thrillerPercentage == 0
            && documentaryPercentage == 0 {

            return
        }
        
        personalityTestServiceModel.save(personalityType: personalityType,
                                         comedyPercentage: comedyPercentage,
                                         actionPercentage: actionPercentage,
                                         dramaPercentage: dramaPercentage,
                                         thrillerPercentage: thrillerPercentage,
                                         documentaryPercentage: documentaryPercentage)
    }
    
    private func savePersonalityTestIfNeeded() {
        guard let personalityType = userPersonalityType, userPersonality != nil else {
            return
        }
        
        saveUserPersonalityTest(dictionaryAnswersCounts: dictionaryAnswersCounts(), personalityType: personalityType)
    }
    
    func savePersonalityType(_ personalityType: PersonalityType?) {
        UserDefaultsHelper.save(object: personalityType?.dictionaryRepresentation(), key: .userPersonality)
    }
    
    var userPersonalityType: PersonalityType? {
        guard let object = UserDefaultsHelper.fetch(key: .userPersonality) else {
            return nil
        }
        return PersonalityType(object: object)
    }
    
    
    var userAnsweredQuestions: [Answer] {
        guard let array = UserDefaultsHelper.fetch(key: .answeredQuestions) as? [[String: Any]] else {
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
            if let id = answer.personalityTypeId {
                counts[id, default: 0] += 1
            }
        }
        
        return counts
    }
    
    var didSkipTestFromLauching = false
    var didSkipTest: Bool {
        guard let value = UserDefaultsHelper.fetch(key: .didSkipTest) as? Bool else {
            return false
        }
        return value
    }
    
    var isPersonalityTestAnswered: Bool {
        return userPersonalityType != nil
    }
    
    // MARK: - Genres & Netflix -
    
    var arrayGenres = [Genres]()
    var arrayNetflixGenres = [Genres]()
    
    // MARK: - Language Detection -
    
    var isLanguagePortuguese: Bool {
        return Locale.preferredLanguages.first == "pt-BR"
    }
    
    // MARK: - Your list movies -
    
    func isMovieInYourWantToSeeList(movie: Movie) -> Bool {
        return arrayUserWantToSeeMovies.filter { $0.movieId == movie.id }.count > 0
    }
    
    func isMovieInYourSeenList(movie: Movie) -> Bool {
        return arrayUserSeenMovies.filter { $0.movieId == movie.id }.count > 0
    }
}
