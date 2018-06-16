//
//  GuestStars.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/30/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct GuestStars: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let name = "name"
        static let character = "character"
        static let id = "id"
        static let gender = "gender"
        static let creditId = "credit_id"
        static let order = "order"
    }
    
    // MARK: Properties
    var name: String?
    var character: String?
    var id: Int?
    var gender: Int?
    var creditId: String?
    var order: Int?
    
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
        character = json?[SerializationKeys.character].string
        id = json?[SerializationKeys.id].int
        gender = json?[SerializationKeys.gender].int
        creditId = json?[SerializationKeys.creditId].string
        order = json?[SerializationKeys.order].int
        
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = character { dictionary[SerializationKeys.character] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = gender { dictionary[SerializationKeys.gender] = value }
        if let value = creditId { dictionary[SerializationKeys.creditId] = value }
        if let value = order { dictionary[SerializationKeys.order] = value }
        return dictionary
    }
}
