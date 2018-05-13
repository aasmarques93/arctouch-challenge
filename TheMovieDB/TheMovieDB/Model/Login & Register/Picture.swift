//
//  Picture.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/31/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Picture: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let data = "data"
    }
    
    // MARK: Properties
    public var data: PictureData?
    
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
        data = PictureData(json: json?[SerializationKeys.data])
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = data { dictionary[SerializationKeys.data] = value.dictionaryRepresentation() }
        return dictionary
    }
    
}
