//
//  MovieDetail.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct MovieDetail: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let budget = "budget"
        static let backdropPath = "backdrop_path"
        static let revenue = "revenue"
        static let voteCount = "vote_count"
        static let overview = "overview"
        static let voteAverage = "vote_average"
        static let video = "video"
        static let imdbId = "imdb_id"
        static let id = "id"
        static let title = "title"
        static let homepage = "homepage"
        static let productionCompanies = "production_companies"
        static let belongsToCollection = "belongs_to_collection"
        static let posterPath = "poster_path"
        static let adult = "adult"
        static let genres = "genres"
        static let spokenLanguages = "spoken_languages"
        static let status = "status"
        static let runtime = "runtime"
        static let originalTitle = "original_title"
        static let releaseDate = "release_date"
        static let originalLanguage = "original_language"
        static let popularity = "popularity"
        static let tagline = "tagline"
        static let productionCountries = "production_countries"
    }
    
    // MARK: Properties
    var budget: Int?
    var backdropPath: String?
    var revenue: Int?
    var voteCount: Int?
    var overview: String?
    var voteAverage: Float?
    var video: Bool? = false
    var imdbId: String?
    var id: Int?
    var title: String?
    var homepage: String?
    var productionCompanies: [ProductionCompanies]?
    var belongsToCollection: BelongsToCollection?
    var posterPath: String?
    var adult: Bool? = false
    var genres: [Genres]?
    var spokenLanguages: [SpokenLanguages]?
    var status: String?
    var runtime: Int?
    var originalTitle: String?
    var releaseDate: String?
    var originalLanguage: String?
    var popularity: Float?
    var tagline: String?
    var productionCountries: [ProductionCountries]?
    
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
        budget = json?[SerializationKeys.budget].int
        backdropPath = json?[SerializationKeys.backdropPath].string
        revenue = json?[SerializationKeys.revenue].int
        voteCount = json?[SerializationKeys.voteCount].int
        overview = json?[SerializationKeys.overview].string
        voteAverage = json?[SerializationKeys.voteAverage].float
        video = json?[SerializationKeys.video].boolValue
        imdbId = json?[SerializationKeys.imdbId].string
        id = json?[SerializationKeys.id].int
        title = json?[SerializationKeys.title].string
        homepage = json?[SerializationKeys.homepage].string
        if let items = json?[SerializationKeys.productionCompanies].array { productionCompanies = items.map { ProductionCompanies(json: $0) } }
        belongsToCollection = BelongsToCollection(json: json?[SerializationKeys.belongsToCollection])
        posterPath = json?[SerializationKeys.posterPath].string
        adult = json?[SerializationKeys.adult].boolValue
        if let items = json?[SerializationKeys.genres].array { genres = items.map { Genres(json: $0) } }
        if let items = json?[SerializationKeys.spokenLanguages].array { spokenLanguages = items.map { SpokenLanguages(json: $0) } }
        status = json?[SerializationKeys.status].string
        runtime = json?[SerializationKeys.runtime].int
        originalTitle = json?[SerializationKeys.originalTitle].string
        releaseDate = json?[SerializationKeys.releaseDate].string
        originalLanguage = json?[SerializationKeys.originalLanguage].string
        popularity = json?[SerializationKeys.popularity].float
        tagline = json?[SerializationKeys.tagline].string
        if let items = json?[SerializationKeys.productionCountries].array { productionCountries = items.map { ProductionCountries(json: $0) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = budget { dictionary[SerializationKeys.budget] = value }
        if let value = backdropPath { dictionary[SerializationKeys.backdropPath] = value }
        if let value = revenue { dictionary[SerializationKeys.revenue] = value }
        if let value = voteCount { dictionary[SerializationKeys.voteCount] = value }
        if let value = overview { dictionary[SerializationKeys.overview] = value }
        if let value = voteAverage { dictionary[SerializationKeys.voteAverage] = value }
        dictionary[SerializationKeys.video] = video
        if let value = imdbId { dictionary[SerializationKeys.imdbId] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = homepage { dictionary[SerializationKeys.homepage] = value }
        if let value = productionCompanies { dictionary[SerializationKeys.productionCompanies] = value.map { $0.dictionaryRepresentation() } }
        if let value = belongsToCollection { dictionary[SerializationKeys.belongsToCollection] = value.dictionaryRepresentation() }
        if let value = posterPath { dictionary[SerializationKeys.posterPath] = value }
        dictionary[SerializationKeys.adult] = adult
        if let value = genres { dictionary[SerializationKeys.genres] = value.map { $0.dictionaryRepresentation() } }
        if let value = spokenLanguages { dictionary[SerializationKeys.spokenLanguages] = value.map { $0.dictionaryRepresentation() } }
        if let value = status { dictionary[SerializationKeys.status] = value }
        if let value = runtime { dictionary[SerializationKeys.runtime] = value }
        if let value = originalTitle { dictionary[SerializationKeys.originalTitle] = value }
        if let value = releaseDate { dictionary[SerializationKeys.releaseDate] = value }
        if let value = originalLanguage { dictionary[SerializationKeys.originalLanguage] = value }
        if let value = popularity { dictionary[SerializationKeys.popularity] = value }
        if let value = tagline { dictionary[SerializationKeys.tagline] = value }
        if let value = productionCountries { dictionary[SerializationKeys.productionCountries] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
}
