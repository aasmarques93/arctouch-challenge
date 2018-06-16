//
//  Results.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/25/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Video: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let name = "name"
        static let id = "id"
        static let key = "key"
        static let iso31661 = "iso_3166_1"
        static let size = "size"
        static let iso6391 = "iso_639_1"
        static let type = "type"
        static let site = "site"
    }
    
    // MARK: Properties
    var name: String?
    var id: String?
    var key: String?
    var iso31661: String?
    var size: Int?
    var iso6391: String?
    var type: String?
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
        self.json = json
        name = json?[SerializationKeys.name].string
        id = json?[SerializationKeys.id].string
        key = json?[SerializationKeys.key].string
        iso31661 = json?[SerializationKeys.iso31661].string
        size = json?[SerializationKeys.size].int
        iso6391 = json?[SerializationKeys.iso6391].string
        type = json?[SerializationKeys.type].string
        site = json?[SerializationKeys.site].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = key { dictionary[SerializationKeys.key] = value }
        if let value = iso31661 { dictionary[SerializationKeys.iso31661] = value }
        if let value = size { dictionary[SerializationKeys.size] = value }
        if let value = iso6391 { dictionary[SerializationKeys.iso6391] = value }
        if let value = type { dictionary[SerializationKeys.type] = value }
        if let value = site { dictionary[SerializationKeys.site] = value }
        return dictionary
    }
}
