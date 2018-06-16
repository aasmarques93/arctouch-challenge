//
//  PersonalityType.swift
//
//  Created by Arthur Augusto Sousa Marques on 5/7/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct PersonalityType: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let id = "id"
        static let title = "title"
        static let genres = "genres"
        static let netflixGenres = "netflixGenres"
        static let text = "text"
        static let color = "color"
    }
    
    // MARK: Properties
    var id: Int?
    var title: String?
    var genres: [Int]?
    var netflixGenres: [Int]?
    var text: String?
    var color: String?
    
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
        title = json?[SerializationKeys.title].string
        if let items = json?[SerializationKeys.genres].array { genres = items.map { $0.intValue } }
        if let items = json?[SerializationKeys.netflixGenres].array { netflixGenres = items.map { $0.intValue } }
        text = json?[SerializationKeys.text].string
        color = json?[SerializationKeys.color].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = genres { dictionary[SerializationKeys.genres] = value }
        if let value = netflixGenres { dictionary[SerializationKeys.netflixGenres] = value }
        if let value = text { dictionary[SerializationKeys.text] = value }
        if let value = color { dictionary[SerializationKeys.color] = value }
        return dictionary
    }
    
}
