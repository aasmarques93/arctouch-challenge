//
//  SpokenLanguages.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct SpokenLanguages: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let iso6391 = "iso_639_1"
        static let name = "name"
    }
    
    // MARK: Properties
    var iso6391: String?
    var name: String?
    
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
        iso6391 = json?[SerializationKeys.iso6391].string
        name = json?[SerializationKeys.name].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = iso6391 { dictionary[SerializationKeys.iso6391] = value }
        if let value = name { dictionary[SerializationKeys.name] = value }
        return dictionary
    }
}
