//
//  EpisodeImagesList.swift
//
//  Created by Arthur Augusto Sousa Marques on 5/5/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct EpisodeImagesList: Model {
    var json: JSON?

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let id = "id"
        static let results = "stills"
    }

    // MARK: Properties
    var id: Int?
    var results: [EpisodeImage]?

    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
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
        self.json = json
        id = json?[SerializationKeys.id].int
        if let items = json?[SerializationKeys.results].array { results = items.map { EpisodeImage(json: $0) } }
    }

    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = results { dictionary[SerializationKeys.results] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }

}
