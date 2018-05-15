//
//  Data.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/31/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct PictureData: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let height = "height"
        static let isSilhouette = "is_silhouette"
        static let url = "url"
        static let width = "width"
    }
    
    // MARK: Properties
    public var height: Int?
    public var isSilhouette: Bool? = false
    public var url: String?
    public var width: Int?
    
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
        height = json?[SerializationKeys.height].int
        isSilhouette = json?[SerializationKeys.isSilhouette].boolValue
        url = json?[SerializationKeys.url].string
        width = json?[SerializationKeys.width].int
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = height { dictionary[SerializationKeys.height] = value }
        dictionary[SerializationKeys.isSilhouette] = isSilhouette
        if let value = url { dictionary[SerializationKeys.url] = value }
        if let value = width { dictionary[SerializationKeys.width] = value }
        return dictionary
    }
    
}
