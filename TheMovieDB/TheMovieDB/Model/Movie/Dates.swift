//
//  Dates.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Dates: Model {
    var json: JSON?
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let maximum = "maximum"
        static let minimum = "minimum"
    }
    
    // MARK: Properties
    var maximum: String?
    var minimum: String?
    
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
        maximum = json?[SerializationKeys.maximum].string
        minimum = json?[SerializationKeys.minimum].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = maximum { dictionary[SerializationKeys.maximum] = value }
        if let value = minimum { dictionary[SerializationKeys.minimum] = value }
        return dictionary
    }
}
