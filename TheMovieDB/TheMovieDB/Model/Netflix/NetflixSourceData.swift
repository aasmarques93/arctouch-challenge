//
//  NetflixSourceData.swift
//
//  Created by Arthur Augusto Sousa Marques on 5/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct NetflixSourceData: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let references = "references"
        static let links = "links"
    }
    
    // MARK: Properties
    var references: NetflixReferences?
    var links: NetflixLinks?
    
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
        references = NetflixReferences(json: json?[SerializationKeys.references])
        links = NetflixLinks(json: json?[SerializationKeys.links])
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = references { dictionary[SerializationKeys.references] = value.dictionaryRepresentation() }
        if let value = links { dictionary[SerializationKeys.links] = value.dictionaryRepresentation() }
        return dictionary
    }
    
}
