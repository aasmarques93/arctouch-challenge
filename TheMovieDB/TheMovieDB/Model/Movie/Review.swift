//
//  Results.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Review: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let content = "content"
        static let author = "author"
        static let id = "id"
        static let url = "url"
    }
    
    // MARK: Properties
    var content: String?
    var author: String?
    var id: String?
    var url: String?
    
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
        content = json?[SerializationKeys.content].string
        author = json?[SerializationKeys.author].string
        id = json?[SerializationKeys.id].string
        url = json?[SerializationKeys.url].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = content { dictionary[SerializationKeys.content] = value }
        if let value = author { dictionary[SerializationKeys.author] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = url { dictionary[SerializationKeys.url] = value }
        return dictionary
    }
}
