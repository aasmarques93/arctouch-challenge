//
//  UserRating.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/24/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserRating: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let movieId = "movieId"
        static let movieImageUrl = "movieImageUrl"
        static let showId = "showId"
        static let showImageUrl = "showImageUrl"
        static let rate = "rate"
    }
    
    // MARK: Properties
    var movieId: Int?
    var movieImageUrl: String?
    var showId: Int?
    var showImageUrl: String?
    var rate: Float?
    
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
        showId = json?[SerializationKeys.showId].int
        showImageUrl = json?[SerializationKeys.showImageUrl].string
        rate = json?[SerializationKeys.rate].float
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = movieId { dictionary[SerializationKeys.movieId] = value }
        if let value = movieImageUrl { dictionary[SerializationKeys.movieImageUrl] = value }
        if let value = showId { dictionary[SerializationKeys.showId] = value }
        if let value = showImageUrl { dictionary[SerializationKeys.showImageUrl] = value }
        if let value = rate { dictionary[SerializationKeys.rate] = value }
        return dictionary
    }
}
