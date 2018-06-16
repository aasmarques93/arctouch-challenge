//
//  VideosList.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/25/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct VideosList: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let id = "id"
        static let results = "results"
    }
    
    // MARK: Properties
    var id: Int?
    var results: [Video]?
    
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
        if let items = json?[SerializationKeys.results].array { results = items.map { Video(json: $0) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = results { dictionary[SerializationKeys.results] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
}
