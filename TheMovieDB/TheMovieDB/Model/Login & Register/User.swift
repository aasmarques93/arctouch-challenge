//
//  User.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/22/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct User: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let username = "username"
        static let name = "name"
        static let email = "email"
        static let id = "_id"
        static let facebookId = "facebookId"
        static let token = "token"
        static let photo = "photo"
        static let picture = "picture"
        static let personality = "personalityTest"
        static let moviesWantToSeeList = "movie"
        static let moviesSeenList = "seenMovies"
        static let showsTrackList = "shows"
        static let ratings = "ratings"
    }
    
    // MARK: Properties
    var username: String?
    var name: String?
    var email: String?
    var id: String?
    var facebookId: String?
    var token: String?
    var photo: String?
    var picture: Picture?
    
    var personality: UserPersonality?

    var moviesWantToSeeList: [UserMovieShow]?
    var moviesSeenList: [UserMovieShow]?
    var showsTrackList: [UserMovieShow]?
    
    var ratings: [UserRating]?
    
    var imageData: Data?
    
    static func createEmptyUser() -> User {
        var dictionary = [String: Any?]()
        dictionary["id"] = 0
        return User(object: dictionary)
    }
    
    // MARK: SwiftyJSON Initializers
    init(object: Any) {
        if let json = object as? JSON {
            self.init(json: json)
            return
        }
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    init(json: JSON?) {
        self.json = json
        username = json?[SerializationKeys.username].string
        name = json?[SerializationKeys.name].string
        email = json?[SerializationKeys.email].string
        id = json?[SerializationKeys.id].string
        facebookId = json?[SerializationKeys.facebookId].string
        token = json?[SerializationKeys.token].string
        photo = json?[SerializationKeys.photo].string
        picture = Picture(json: json?[SerializationKeys.picture])
        personality = UserPersonality(json: json?[SerializationKeys.personality])
        if let items = json?[SerializationKeys.moviesWantToSeeList].array { moviesWantToSeeList = items.map { UserMovieShow(json: $0) } }
        if let items = json?[SerializationKeys.moviesSeenList].array { moviesSeenList = items.map { UserMovieShow(json: $0) } }
        if let items = json?[SerializationKeys.showsTrackList].array { showsTrackList = items.map { UserMovieShow(json: $0) } }
        if let items = json?[SerializationKeys.ratings].array { ratings = items.map { UserRating(json: $0) } }
    }
    
    /// Generatingss description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = username { dictionary[SerializationKeys.username] = value }
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = email { dictionary[SerializationKeys.email] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = facebookId { dictionary[SerializationKeys.facebookId] = value }
        if let value = token { dictionary[SerializationKeys.token] = value }
        if let value = photo { dictionary[SerializationKeys.photo] = value }
        if let value = picture { dictionary[SerializationKeys.picture] = value.dictionaryRepresentation() }
        if let value = personality { dictionary[SerializationKeys.personality] = value.dictionaryRepresentation() }
        if let value = moviesWantToSeeList { dictionary[SerializationKeys.moviesWantToSeeList] = value.map { $0.dictionaryRepresentation() } }
        if let value = moviesSeenList { dictionary[SerializationKeys.moviesSeenList] = value.map { $0.dictionaryRepresentation() } }
        if let value = showsTrackList { dictionary[SerializationKeys.showsTrackList] = value.map { $0.dictionaryRepresentation() } }
        if let value = ratings { dictionary[SerializationKeys.ratings] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
}
