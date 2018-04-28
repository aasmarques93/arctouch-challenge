//
//  TVShowDetail.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class TVShowDetail: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let backdropPath = "backdrop_path"
    static let numberOfEpisodes = "number_of_episodes"
    static let firstAirDate = "first_air_date"
    static let originalName = "original_name"
    static let languages = "languages"
    static let type = "type"
    static let voteCount = "vote_count"
    static let lastAirDate = "last_air_date"
    static let overview = "overview"
    static let numberOfSeasons = "number_of_seasons"
    static let voteAverage = "vote_average"
    static let id = "id"
    static let homepage = "homepage"
    static let productionCompanies = "production_companies"
    static let posterPath = "poster_path"
    static let originCountry = "origin_country"
    static let name = "name"
    static let genres = "genres"
    static let episodeRunTime = "episode_run_time"
    static let inProduction = "in_production"
    static let networks = "networks"
    static let status = "status"
    static let seasons = "seasons"
    static let popularity = "popularity"
    static let originalLanguage = "original_language"
    static let createdBy = "created_by"
  }

  // MARK: Properties
  public var backdropPath: String?
  public var numberOfEpisodes: Int?
  public var firstAirDate: String?
  public var originalName: String?
  public var languages: [String]?
  public var type: String?
  public var voteCount: Int?
  public var lastAirDate: String?
  public var overview: String?
  public var numberOfSeasons: Int?
  public var voteAverage: Float?
  public var id: Int?
  public var homepage: String?
  public var productionCompanies: [ProductionCompanies]?
  public var posterPath: String?
  public var originCountry: [String]?
  public var name: String?
  public var genres: [Genres]?
  public var episodeRunTime: [Int]?
  public var inProduction: Bool? = false
  public var networks: [Networks]?
  public var status: String?
  public var seasons: [Seasons]?
  public var popularity: Float?
  public var originalLanguage: String?
  public var createdBy: [CreatedBy]?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    backdropPath = json[SerializationKeys.backdropPath].string
    numberOfEpisodes = json[SerializationKeys.numberOfEpisodes].int
    firstAirDate = json[SerializationKeys.firstAirDate].string
    originalName = json[SerializationKeys.originalName].string
    if let items = json[SerializationKeys.languages].array { languages = items.map { $0.stringValue } }
    type = json[SerializationKeys.type].string
    voteCount = json[SerializationKeys.voteCount].int
    lastAirDate = json[SerializationKeys.lastAirDate].string
    overview = json[SerializationKeys.overview].string
    numberOfSeasons = json[SerializationKeys.numberOfSeasons].int
    voteAverage = json[SerializationKeys.voteAverage].float
    id = json[SerializationKeys.id].int
    homepage = json[SerializationKeys.homepage].string
    if let items = json[SerializationKeys.productionCompanies].array { productionCompanies = items.map { ProductionCompanies(json: $0) } }
    posterPath = json[SerializationKeys.posterPath].string
    if let items = json[SerializationKeys.originCountry].array { originCountry = items.map { $0.stringValue } }
    name = json[SerializationKeys.name].string
    if let items = json[SerializationKeys.genres].array { genres = items.map { Genres(json: $0) } }
    if let items = json[SerializationKeys.episodeRunTime].array { episodeRunTime = items.map { $0.intValue } }
    inProduction = json[SerializationKeys.inProduction].boolValue
    if let items = json[SerializationKeys.networks].array { networks = items.map { Networks(json: $0) } }
    status = json[SerializationKeys.status].string
    if let items = json[SerializationKeys.seasons].array { seasons = items.map { Seasons(json: $0) } }
    popularity = json[SerializationKeys.popularity].float
    originalLanguage = json[SerializationKeys.originalLanguage].string
    if let items = json[SerializationKeys.createdBy].array { createdBy = items.map { CreatedBy(json: $0) } }
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = backdropPath { dictionary[SerializationKeys.backdropPath] = value }
    if let value = numberOfEpisodes { dictionary[SerializationKeys.numberOfEpisodes] = value }
    if let value = firstAirDate { dictionary[SerializationKeys.firstAirDate] = value }
    if let value = originalName { dictionary[SerializationKeys.originalName] = value }
    if let value = languages { dictionary[SerializationKeys.languages] = value }
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = voteCount { dictionary[SerializationKeys.voteCount] = value }
    if let value = lastAirDate { dictionary[SerializationKeys.lastAirDate] = value }
    if let value = overview { dictionary[SerializationKeys.overview] = value }
    if let value = numberOfSeasons { dictionary[SerializationKeys.numberOfSeasons] = value }
    if let value = voteAverage { dictionary[SerializationKeys.voteAverage] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = homepage { dictionary[SerializationKeys.homepage] = value }
    if let value = productionCompanies { dictionary[SerializationKeys.productionCompanies] = value.map { $0.dictionaryRepresentation() } }
    if let value = posterPath { dictionary[SerializationKeys.posterPath] = value }
    if let value = originCountry { dictionary[SerializationKeys.originCountry] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = genres { dictionary[SerializationKeys.genres] = value.map { $0.dictionaryRepresentation() } }
    if let value = episodeRunTime { dictionary[SerializationKeys.episodeRunTime] = value }
    dictionary[SerializationKeys.inProduction] = inProduction
    if let value = networks { dictionary[SerializationKeys.networks] = value.map { $0.dictionaryRepresentation() } }
    if let value = status { dictionary[SerializationKeys.status] = value }
    if let value = seasons { dictionary[SerializationKeys.seasons] = value.map { $0.dictionaryRepresentation() } }
    if let value = popularity { dictionary[SerializationKeys.popularity] = value }
    if let value = originalLanguage { dictionary[SerializationKeys.originalLanguage] = value }
    if let value = createdBy { dictionary[SerializationKeys.createdBy] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
