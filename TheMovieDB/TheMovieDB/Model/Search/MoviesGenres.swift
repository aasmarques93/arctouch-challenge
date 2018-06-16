//
//  MoviesGenres.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct MoviesGenres: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let genres = "genres"
    }
    
    // MARK: Properties
    var genres: [Genres]?
    
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
        if let items = json?[SerializationKeys.genres].array { genres = items.map { Genres(json: $0) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = genres { dictionary[SerializationKeys.genres] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
}
