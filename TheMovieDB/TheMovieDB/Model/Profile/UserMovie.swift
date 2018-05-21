//
//  UserMovie.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserMovie: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let movieId = "movieId"
        static let movieImageUrl = "movieImageUrl"
    }
    
    // MARK: Properties
    var movieId: Int?
    var movieImageUrl: String?
    
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
        movieId = json?[SerializationKeys.movieId].int
        movieImageUrl = json?[SerializationKeys.movieImageUrl].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = movieId { dictionary[SerializationKeys.movieId] = value }
        if let value = movieImageUrl { dictionary[SerializationKeys.movieImageUrl] = value }
        return dictionary
    }
}
