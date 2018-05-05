//
//  BelongsToCollection.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct BelongsToCollection: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let posterPath = "poster_path"
        static let name = "name"
        static let backdropPath = "backdrop_path"
        static let id = "id"
    }
    
    // MARK: Properties
    var posterPath: String?
    var name: String?
    var backdropPath: String?
    var id: Int?
    
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
        posterPath = json?[SerializationKeys.posterPath].string
        name = json?[SerializationKeys.name].string
        backdropPath = json?[SerializationKeys.backdropPath].string
        id = json?[SerializationKeys.id].int
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = posterPath { dictionary[SerializationKeys.posterPath] = value }
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = backdropPath { dictionary[SerializationKeys.backdropPath] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        return dictionary
    }
}
