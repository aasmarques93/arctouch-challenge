//
//  ProductionCompanies.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct ProductionCompanies: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let originCountry = "origin_country"
        static let name = "name"
        static let id = "id"
    }
    
    // MARK: Properties
    var originCountry: String?
    var name: String?
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
        originCountry = json?[SerializationKeys.originCountry].string
        name = json?[SerializationKeys.name].string
        id = json?[SerializationKeys.id].int
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = originCountry { dictionary[SerializationKeys.originCountry] = value }
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        return dictionary
    }
}
