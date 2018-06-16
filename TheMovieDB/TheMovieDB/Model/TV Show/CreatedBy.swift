//
//  CreatedBy.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct CreatedBy: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let gender = "gender"
        static let name = "name"
        static let profilePath = "profile_path"
        static let id = "id"
    }
    
    // MARK: Properties
    var gender: Int?
    var name: String?
    var profilePath: String?
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
        gender = json?[SerializationKeys.gender].int
        name = json?[SerializationKeys.name].string
        profilePath = json?[SerializationKeys.profilePath].string
        id = json?[SerializationKeys.id].int
        
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = gender { dictionary[SerializationKeys.gender] = value }
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = profilePath { dictionary[SerializationKeys.profilePath] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        return dictionary
    }
}
