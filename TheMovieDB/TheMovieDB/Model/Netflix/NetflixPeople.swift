//
//  NetflixPeople.swift
//
//  Created by Arthur Augusto Sousa Marques on 5/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct NetflixPeople: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let hasPoster = "has_poster"
        static let name = "name"
        static let roleType = "role_type"
        static let slug = "slug"
        static let id = "id"
        static let hasSquare = "has_square"
    }
    
    // MARK: Properties
    var hasPoster: Bool? = false
    var name: String?
    var roleType: Int?
    var slug: String?
    var id: String?
    var hasSquare: Bool? = false
    
    // MARK: SwiftyJSON Initializers
    init(object: Any) {
        if let json = object as? JSON {
            self.init(json: json)
            return
        }
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    init(json: JSON?) {
        hasPoster = json?[SerializationKeys.hasPoster].boolValue
        name = json?[SerializationKeys.name].string
        roleType = json?[SerializationKeys.roleType].int
        slug = json?[SerializationKeys.slug].string
        id = json?[SerializationKeys.id].string
        hasSquare = json?[SerializationKeys.hasSquare].boolValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[SerializationKeys.hasPoster] = hasPoster
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = roleType { dictionary[SerializationKeys.roleType] = value }
        if let value = slug { dictionary[SerializationKeys.slug] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        dictionary[SerializationKeys.hasSquare] = hasSquare
        return dictionary
    }
    
}
