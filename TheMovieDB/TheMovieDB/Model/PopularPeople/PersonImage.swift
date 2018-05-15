//
//  Profiles.swift
//
//  Created by Arthur Augusto Sousa Marques on 5/5/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct PersonImage: Model {
    var json: JSON?

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let height = "height"
        static let voteAverage = "vote_average"
        static let aspectRatio = "aspect_ratio"
        static let width = "width"
        static let voteCount = "vote_count"
        static let filePath = "file_path"
    }

    // MARK: Properties
    var height: Int?
    var voteAverage: Float?
    var aspectRatio: Float?
    var width: Int?
    var voteCount: Int?
    var filePath: String?

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
        height = json?[SerializationKeys.height].int
        voteAverage = json?[SerializationKeys.voteAverage].float
        aspectRatio = json?[SerializationKeys.aspectRatio].float
        width = json?[SerializationKeys.width].int
        voteCount = json?[SerializationKeys.voteCount].int
        filePath = json?[SerializationKeys.filePath].string
    }

    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = height { dictionary[SerializationKeys.height] = value }
        if let value = voteAverage { dictionary[SerializationKeys.voteAverage] = value }
        if let value = aspectRatio { dictionary[SerializationKeys.aspectRatio] = value }
        if let value = width { dictionary[SerializationKeys.width] = value }
        if let value = voteCount { dictionary[SerializationKeys.voteCount] = value }
        if let value = filePath { dictionary[SerializationKeys.filePath] = value }
        return dictionary
    }

}
