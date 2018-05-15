//
//  NetflixLinks.swift
//
//  Created by Arthur Augusto Sousa Marques on 5/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct NetflixLinks: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let ios = "ios"
        static let web = "web"
        static let android = "android"
    }
    
    // MARK: Properties
    var ios: String?
    var web: String?
    var android: String?
    
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
        ios = json?[SerializationKeys.ios].string
        web = json?[SerializationKeys.web].string
        android = json?[SerializationKeys.android].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = ios { dictionary[SerializationKeys.ios] = value }
        if let value = web { dictionary[SerializationKeys.web] = value }
        if let value = android { dictionary[SerializationKeys.android] = value }
        return dictionary
    }
    
}
