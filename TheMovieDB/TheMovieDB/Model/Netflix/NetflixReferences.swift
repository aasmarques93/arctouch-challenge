//
//  NetflixReferences.swift
//
//  Created by Arthur Augusto Sousa Marques on 5/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct NetflixReferences: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let ios = "ios"
        static let web = "web"
        static let android = "android"
    }
    
    // MARK: Properties
    var ios: NetflixIos?
    var web: NetflixWeb?
    var android: NetflixAndroid?
    
    // MARK: SwiftyJSON Initializers
    init(object: Any) {
        if let json = object as? JSON {
            self.init(json: json)
            return
        }
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    init(json: JSON?) {
        ios = NetflixIos(json: json?[SerializationKeys.ios])
        web = NetflixWeb(json: json?[SerializationKeys.web])
        android = NetflixAndroid(json: json?[SerializationKeys.android])
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = ios { dictionary[SerializationKeys.ios] = value.dictionaryRepresentation() }
        if let value = web { dictionary[SerializationKeys.web] = value.dictionaryRepresentation() }
        if let value = android { dictionary[SerializationKeys.android] = value.dictionaryRepresentation() }
        return dictionary
    }
    
}
