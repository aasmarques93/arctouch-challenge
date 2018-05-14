//
//  NetflixAvailability.swift
//
//  Created by Arthur Augusto Sousa Marques on 5/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct NetflixAvailability: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let sourceData = "source_data"
        static let sourceName = "source_name"
        static let sourceId = "source_id"
        static let accessType = "access_type"
    }
    
    // MARK: Properties
    var sourceData: NetflixSourceData?
    var sourceName: String?
    var sourceId: String?
    var accessType: Int?
    
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
        sourceData = NetflixSourceData(json: json?[SerializationKeys.sourceData])
        sourceName = json?[SerializationKeys.sourceName].string
        sourceId = json?[SerializationKeys.sourceId].string
        accessType = json?[SerializationKeys.accessType].int
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = sourceData { dictionary[SerializationKeys.sourceData] = value.dictionaryRepresentation() }
        if let value = sourceName { dictionary[SerializationKeys.sourceName] = value }
        if let value = sourceId { dictionary[SerializationKeys.sourceId] = value }
        if let value = accessType { dictionary[SerializationKeys.accessType] = value }
        return dictionary
    }
    
}
