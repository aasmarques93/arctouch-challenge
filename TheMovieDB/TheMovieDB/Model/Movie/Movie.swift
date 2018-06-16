//
//  Results.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Movie: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    struct SerializationKeys {
        static let posterPath = "poster_path"
        static let backdropPath = "backdrop_path"
        static let genreIds = "genre_ids"
        static let voteCount = "vote_count"
        static let overview = "overview"
        static let originalTitle = "original_title"
        static let originalName = "original_name"
        static let voteAverage = "vote_average"
        static let popularity = "popularity"
        static let id = "id"
        static let originalLanguage = "original_language"
        static let releaseDate = "release_date"
        static let video = "video"
        static let title = "title"
        static let adult = "adult"
        static let firstAirDate = "first_air_date"
    }
    
    // MARK: Properties
    var posterPath: String?
    var backdropPath: String?
    var genreIds: [Int]?
    var voteCount: Int?
    var overview: String?
    var originalTitle: String?
    var originalName: String?
    var voteAverage: Float?
    var popularity: Float?
    var id: Int?
    var originalLanguage: String?
    var releaseDate: String?
    var video: Bool? = false
    var title: String?
    var adult: Bool? = false
    var firstAirDate: String?
    
    var imageData: Data?
    
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
        posterPath = json?[SerializationKeys.posterPath].string
        backdropPath = json?[SerializationKeys.backdropPath].string
        if let items = json?[SerializationKeys.genreIds].array { genreIds = items.map { $0.intValue } }
        voteCount = json?[SerializationKeys.voteCount].int
        overview = json?[SerializationKeys.overview].string
        originalTitle = json?[SerializationKeys.originalTitle].string
        originalName = json?[SerializationKeys.originalName].string
        voteAverage = json?[SerializationKeys.voteAverage].float
        popularity = json?[SerializationKeys.popularity].float
        id = json?[SerializationKeys.id].int
        originalLanguage = json?[SerializationKeys.originalLanguage].string
        releaseDate = json?[SerializationKeys.releaseDate].string
        video = json?[SerializationKeys.video].boolValue
        title = json?[SerializationKeys.title].string
        adult = json?[SerializationKeys.adult].boolValue
        firstAirDate = json?[SerializationKeys.firstAirDate].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = posterPath { dictionary[SerializationKeys.posterPath] = value }
        if let value = backdropPath { dictionary[SerializationKeys.backdropPath] = value }
        if let value = genreIds { dictionary[SerializationKeys.genreIds] = value }
        if let value = voteCount { dictionary[SerializationKeys.voteCount] = value }
        if let value = overview { dictionary[SerializationKeys.overview] = value }
        if let value = originalTitle { dictionary[SerializationKeys.originalTitle] = value }
        if let value = originalName { dictionary[SerializationKeys.originalName] = value }
        if let value = voteAverage { dictionary[SerializationKeys.voteAverage] = value }
        if let value = popularity { dictionary[SerializationKeys.popularity] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = originalLanguage { dictionary[SerializationKeys.originalLanguage] = value }
        if let value = releaseDate { dictionary[SerializationKeys.releaseDate] = value }
        dictionary[SerializationKeys.video] = video
        if let value = title { dictionary[SerializationKeys.title] = value }
        dictionary[SerializationKeys.adult] = adult
        if let value = firstAirDate { dictionary[SerializationKeys.firstAirDate] = value }
        return dictionary
    }
}
