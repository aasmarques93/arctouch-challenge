//
//  Results.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct TVShow: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    struct SerializationKeys {
        static let originCountry = "origin_country"
        static let name = "name"
        static let genreIds = "genre_ids"
        static let firstAirDate = "first_air_date"
        static let originalName = "original_name"
        static let voteCount = "vote_count"
        static let overview = "overview"
        static let popularity = "popularity"
        static let voteAverage = "vote_average"
        static let id = "id"
        static let originalLanguage = "original_language"
        static let posterPath = "poster_path"
        static let backdropPath = "backdrop_path"
    }
    
    // MARK: Properties
    var originCountry: [String]?
    var name: String?
    var genreIds: [Int]?
    var firstAirDate: String?
    var originalName: String?
    var voteCount: Int?
    var overview: String?
    var popularity: Float?
    var voteAverage: Int?
    var id: Int?
    var originalLanguage: String?
    var posterPath: String?
    var backdropPath: String?
    
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
        if let items = json?[SerializationKeys.originCountry].array { originCountry = items.map { $0.stringValue } }
        name = json?[SerializationKeys.name].string
        if let items = json?[SerializationKeys.genreIds].array { genreIds = items.map { $0.intValue } }
        firstAirDate = json?[SerializationKeys.firstAirDate].string
        originalName = json?[SerializationKeys.originalName].string
        voteCount = json?[SerializationKeys.voteCount].int
        overview = json?[SerializationKeys.overview].string
        popularity = json?[SerializationKeys.popularity].float
        voteAverage = json?[SerializationKeys.voteAverage].int
        id = json?[SerializationKeys.id].int
        originalLanguage = json?[SerializationKeys.originalLanguage].string
        posterPath = json?[SerializationKeys.posterPath].string
        backdropPath = json?[SerializationKeys.backdropPath].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = originCountry { dictionary[SerializationKeys.originCountry] = value }
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = genreIds { dictionary[SerializationKeys.genreIds] = value }
        if let value = firstAirDate { dictionary[SerializationKeys.firstAirDate] = value }
        if let value = originalName { dictionary[SerializationKeys.originalName] = value }
        if let value = voteCount { dictionary[SerializationKeys.voteCount] = value }
        if let value = overview { dictionary[SerializationKeys.overview] = value }
        if let value = popularity { dictionary[SerializationKeys.popularity] = value }
        if let value = voteAverage { dictionary[SerializationKeys.voteAverage] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = originalLanguage { dictionary[SerializationKeys.originalLanguage] = value }
        if let value = posterPath { dictionary[SerializationKeys.posterPath] = value }
        if let value = backdropPath { dictionary[SerializationKeys.backdropPath] = value }
        return dictionary
    }
}
