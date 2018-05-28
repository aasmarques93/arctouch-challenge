//
//  UserMovieShow.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserMovieShow: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let movieId = "movieId"
        static let movieImageUrl = "movieImageUrl"
        static let showId = "showId"
        static let showImageUrl = "showImageUrl"
        static let season = "season"
        static let episode = "episode"
        static let updateAt = "updateAt"
    }
    
    // MARK: Properties
    var movieId: Int?
    var movieImageUrl: String?
    var showId: Int?
    var showImageUrl: String?
    var season: Int?
    var episode: Int?
    var updateAt: String?
    
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
        season = json?[SerializationKeys.season].int
        episode = json?[SerializationKeys.episode].int
        updateAt = json?[SerializationKeys.updateAt].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = movieId { dictionary[SerializationKeys.movieId] = value }
        if let value = movieImageUrl { dictionary[SerializationKeys.movieImageUrl] = value }
        if let value = showId { dictionary[SerializationKeys.showId] = value }
        if let value = showImageUrl { dictionary[SerializationKeys.showImageUrl] = value }
        if let value = season { dictionary[SerializationKeys.season] = value }
        if let value = episode { dictionary[SerializationKeys.episode] = value }
        if let value = updateAt { dictionary[SerializationKeys.updateAt] = value }
        return dictionary
    }
}
