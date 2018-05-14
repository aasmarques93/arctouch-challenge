//
//  Netflix.swift
//
//  Created by Arthur Augusto Sousa Marques on 5/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Netflix: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let sources = "sources"
        static let hasBackdrop = "has_backdrop"
        static let rtCriticsRating = "rt_critics_rating"
        static let classification = "classification"
        static let contentType = "content_type"
        static let hasPoster = "has_poster"
        static let id = "id"
        static let tracking = "tracking"
        static let releasedOn = "released_on"
        static let slug = "slug"
        static let changingOn = "changing_on"
        static let title = "title"
        static let imdbRating = "imdb_rating"
    }
    
    // MARK: Properties
    var sources: [String]?
    var hasBackdrop: Bool? = false
    var rtCriticsRating: Int?
    var classification: String?
    var contentType: String?
    var hasPoster: Bool? = false
    var id: String?
    var tracking: Bool? = false
    var releasedOn: String?
    var slug: String?
    var changingOn: String?
    var title: String?
    var imdbRating: Float?
    
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
        if let items = json?[SerializationKeys.sources].array { sources = items.map { $0.stringValue } }
        hasBackdrop = json?[SerializationKeys.hasBackdrop].boolValue
        rtCriticsRating = json?[SerializationKeys.rtCriticsRating].int
        classification = json?[SerializationKeys.classification].string
        contentType = json?[SerializationKeys.contentType].string
        hasPoster = json?[SerializationKeys.hasPoster].boolValue
        id = json?[SerializationKeys.id].string
        tracking = json?[SerializationKeys.tracking].boolValue
        releasedOn = json?[SerializationKeys.releasedOn].string
        slug = json?[SerializationKeys.slug].string
        changingOn = json?[SerializationKeys.changingOn].string
        title = json?[SerializationKeys.title].string
        imdbRating = json?[SerializationKeys.imdbRating].float
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = sources { dictionary[SerializationKeys.sources] = value }
        dictionary[SerializationKeys.hasBackdrop] = hasBackdrop
        if let value = rtCriticsRating { dictionary[SerializationKeys.rtCriticsRating] = value }
        if let value = classification { dictionary[SerializationKeys.classification] = value }
        if let value = contentType { dictionary[SerializationKeys.contentType] = value }
        dictionary[SerializationKeys.hasPoster] = hasPoster
        if let value = id { dictionary[SerializationKeys.id] = value }
        dictionary[SerializationKeys.tracking] = tracking
        if let value = releasedOn { dictionary[SerializationKeys.releasedOn] = value }
        if let value = slug { dictionary[SerializationKeys.slug] = value }
        if let value = changingOn { dictionary[SerializationKeys.changingOn] = value }
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = imdbRating { dictionary[SerializationKeys.imdbRating] = value }
        return dictionary
    }
    
}
