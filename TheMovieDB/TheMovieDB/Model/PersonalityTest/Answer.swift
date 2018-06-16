//
//  Answers.swift
//
//  Created by Arthur Augusto Sousa Marques on 5/7/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Answer: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    struct SerializationKeys {
        static let id = "id"
        static let personalityTypeId = "personalityTypeId"
        static let title = "title"
        static let skip = "skip"
    }
    
    // MARK: Properties
    var id: Int?
    var personalityTypeId: Int?
    var title: String?
    var skip: Bool?
    
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
        id = json?[SerializationKeys.id].int
        personalityTypeId = json?[SerializationKeys.personalityTypeId].int
        title = json?[SerializationKeys.title].string
        skip = json?[SerializationKeys.skip].boolValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = personalityTypeId { dictionary[SerializationKeys.personalityTypeId] = value }
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = skip { dictionary[SerializationKeys.skip] = value }
        return dictionary
    }
    
}
