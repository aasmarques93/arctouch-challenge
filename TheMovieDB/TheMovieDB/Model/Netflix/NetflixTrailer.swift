//
//  NetflixTrailer.swift
//
//  Created by Arthur Augusto Sousa Marques on 5/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct NetflixTrailer: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let key = "key"
        static let site = "site"
    }
    
    // MARK: Properties
    var key: String?
    var site: String?
    
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
        key = json?[SerializationKeys.key].string
        site = json?[SerializationKeys.site].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = key { dictionary[SerializationKeys.key] = value }
        if let value = site { dictionary[SerializationKeys.site] = value }
        return dictionary
    }
    
}
