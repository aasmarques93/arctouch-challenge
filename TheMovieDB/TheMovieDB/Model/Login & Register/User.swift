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
        static let name = "name"
        static let email = "email"
        static let id = "id"
        static let facebookId = "facebook_id"
        static let token = "token"
        static let photo = "photo"
        static let phone = "phone"
        static let picture = "picture"
    }
    
    // MARK: Properties
    var name: String?
    var email: String?
    var id: Int?
    var facebookId: String?
    var token: String?
    var photo: String?
    var phone: String?
    
    var picture: Picture?
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
        name = json?[SerializationKeys.name].string
        email = json?[SerializationKeys.email].string
        id = json?[SerializationKeys.id].int
        facebookId = json?[SerializationKeys.id].string
        token = json?[SerializationKeys.token].string
        photo = json?[SerializationKeys.photo].string
        phone = json?[SerializationKeys.phone].string
        picture = Picture(json: json?[SerializationKeys.picture])
    }
    
    /// Generatingss description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = email { dictionary[SerializationKeys.email] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = facebookId { dictionary[SerializationKeys.id] = value }
        if let value = token { dictionary[SerializationKeys.token] = value }
        if let value = photo { dictionary[SerializationKeys.photo] = value }
        if let value = phone { dictionary[SerializationKeys.phone] = value }
        if let value = picture { dictionary[SerializationKeys.picture] = value.dictionaryRepresentation() }
        return dictionary
    }
}
