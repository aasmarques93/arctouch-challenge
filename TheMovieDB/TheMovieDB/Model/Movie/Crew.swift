//
//  Crew.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Crew: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let name = "name"
        static let profilePath = "profile_path"
        static let department = "department"
        static let id = "id"
        static let job = "job"
        static let gender = "gender"
        static let creditId = "credit_id"
    }
    
    // MARK: Properties
    var name: String?
    var profilePath: String?
    var department: String?
    var id: Int?
    var job: String?
    var gender: Int?
    var creditId: String?
    
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
        department = json?[SerializationKeys.department].string
        id = json?[SerializationKeys.id].int
        job = json?[SerializationKeys.job].string
        gender = json?[SerializationKeys.gender].int
        creditId = json?[SerializationKeys.creditId].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = profilePath { dictionary[SerializationKeys.profilePath] = value }
        if let value = department { dictionary[SerializationKeys.department] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = job { dictionary[SerializationKeys.job] = value }
        if let value = gender { dictionary[SerializationKeys.gender] = value }
        if let value = creditId { dictionary[SerializationKeys.creditId] = value }
        return dictionary
    }
}
