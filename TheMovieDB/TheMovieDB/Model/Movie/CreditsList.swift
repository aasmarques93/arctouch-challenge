//
//  CreditsList.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct CreditsList: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let id = "id"
        static let cast = "cast"
        static let crew = "crew"
    }
    
    // MARK: Properties
    var id: Int?
    var cast: [Cast]?
    var crew: [Crew]?
    
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
        if let items = json?[SerializationKeys.cast].array { cast = items.map { Cast(json: $0) } }
        if let items = json?[SerializationKeys.crew].array { crew = items.map { Crew(json: $0) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = cast { dictionary[SerializationKeys.cast] = value.map { $0.dictionaryRepresentation() } }
        if let value = crew { dictionary[SerializationKeys.crew] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
}
