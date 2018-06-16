//
//  Person.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Person: Model {
    var json: JSON?
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let name = "name"
        static let profilePath = "profile_path"
        static let alsoKnownAs = "also_known_as"
        static let gender = "gender"
        static let birthday = "birthday"
        static let placeOfBirth = "place_of_birth"
        static let popularity = "popularity"
        static let id = "id"
        static let biography = "biography"
        static let imdbId = "imdb_id"
        static let adult = "adult"
        static let movies = "known_for"
    }
    
    // MARK: Properties
    var name: String?
    var profilePath: String?
    var alsoKnownAs: [String]?
    var gender: Int?
    var birthday: String?
    var placeOfBirth: String?
    var popularity: Float?
    var id: Int?
    var biography: String?
    var imdbId: String?
    var adult: Bool? = false
    var movies: [Movie]?
    
    var imageData: Data?
    
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
        name = json?[SerializationKeys.name].string
        profilePath = json?[SerializationKeys.profilePath].string
        if let items = json?[SerializationKeys.alsoKnownAs].array { alsoKnownAs = items.map { $0.stringValue } }
        gender = json?[SerializationKeys.gender].int
        birthday = json?[SerializationKeys.birthday].string
        placeOfBirth = json?[SerializationKeys.placeOfBirth].string
        popularity = json?[SerializationKeys.popularity].float
        id = json?[SerializationKeys.id].int
        biography = json?[SerializationKeys.biography].string
        imdbId = json?[SerializationKeys.imdbId].string
        adult = json?[SerializationKeys.adult].boolValue
        if let items = json?[SerializationKeys.movies].array { movies = items.map { Movie(json: $0) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = profilePath { dictionary[SerializationKeys.profilePath] = value }
        if let value = alsoKnownAs { dictionary[SerializationKeys.alsoKnownAs] = value }
        if let value = gender { dictionary[SerializationKeys.gender] = value }
        if let value = birthday { dictionary[SerializationKeys.birthday] = value }
        if let value = placeOfBirth { dictionary[SerializationKeys.placeOfBirth] = value }
        if let value = popularity { dictionary[SerializationKeys.popularity] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = biography { dictionary[SerializationKeys.biography] = value }
        if let value = imdbId { dictionary[SerializationKeys.imdbId] = value }
        if let value = movies { dictionary[SerializationKeys.movies] = value.map { $0.dictionaryRepresentation() } }
        dictionary[SerializationKeys.adult] = adult
        return dictionary
    }
}
