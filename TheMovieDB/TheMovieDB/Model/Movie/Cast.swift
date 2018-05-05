//
//  Cast.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Cast: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let name = "name"
        static let castId = "cast_id"
        static let originalTitle = "original_title"
        static let character = "character"
        static let id = "id"
        static let gender = "gender"
        static let creditId = "credit_id"
        static let order = "order"
        static let profilePath = "profile_path"
        static let posterPath = "poster_path"
        static let backdropPath = "backdrop_path"
    }
    
    // MARK: Properties
    var name: String?
    var castId: Int?
    var originalTitle: String?
    var character: String?
    var id: Int?
    var gender: Int?
    var creditId: String?
    var order: Int?
    var profilePath: String?
    var posterPath: String?
    var backdropPath: String?
    
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
        castId = json?[SerializationKeys.castId].int
        originalTitle = json?[SerializationKeys.originalTitle].string
        character = json?[SerializationKeys.character].string
        id = json?[SerializationKeys.id].int
        gender = json?[SerializationKeys.gender].int
        creditId = json?[SerializationKeys.creditId].string
        order = json?[SerializationKeys.order].int
        profilePath = json?[SerializationKeys.profilePath].string
        posterPath = json?[SerializationKeys.posterPath].string
        backdropPath = json?[SerializationKeys.backdropPath].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = castId { dictionary[SerializationKeys.castId] = value }
        if let value = originalTitle { dictionary[SerializationKeys.originalTitle] = value }
        if let value = character { dictionary[SerializationKeys.character] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = gender { dictionary[SerializationKeys.gender] = value }
        if let value = creditId { dictionary[SerializationKeys.creditId] = value }
        if let value = order { dictionary[SerializationKeys.order] = value }
        if let value = profilePath { dictionary[SerializationKeys.profilePath] = value }
        if let value = posterPath { dictionary[SerializationKeys.posterPath] = value }
        if let value = backdropPath { dictionary[SerializationKeys.backdropPath] = value }
        return dictionary
    }
}
