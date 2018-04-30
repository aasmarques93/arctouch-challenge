//
//  KnownFor.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class KnownFor: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let posterPath = "poster_path"
    static let originCountry = "origin_country"
    static let name = "name"
    static let adult = "adult"
    static let genreIds = "genre_ids"
    static let firstAirDate = "first_air_date"
    static let originalName = "original_name"
    static let voteCount = "vote_count"
    static let overview = "overview"
    static let originalTitle = "original_title"
    static let voteAverage = "vote_average"
    static let popularity = "popularity"
    static let id = "id"
    static let originalLanguage = "original_language"
    static let releaseDate = "release_date"
    static let video = "video"
    static let title = "title"
    static let mediaType = "media_type"
  }

  // MARK: Properties
  public var posterPath: String?
  public var originCountry: [String]?
  public var name: String?
  public var adult: Bool? = false
  public var genreIds: [Int]?
  public var firstAirDate: String?
  public var originalName: String?
  public var voteCount: Int?
  public var overview: String?
  public var originalTitle: String?
  public var voteAverage: Int?
  public var popularity: Float?
  public var id: Int?
  public var originalLanguage: String?
  public var releaseDate: String?
  public var video: Bool? = false
  public var title: String?
  public var mediaType: String?

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
    posterPath = json[SerializationKeys.posterPath].string
    if let items = json[SerializationKeys.originCountry].array { originCountry = items.map { $0.stringValue } }
    name = json[SerializationKeys.name].string
    adult = json[SerializationKeys.adult].boolValue
    if let items = json[SerializationKeys.genreIds].array { genreIds = items.map { $0.intValue } }
    firstAirDate = json[SerializationKeys.firstAirDate].string
    originalName = json[SerializationKeys.originalName].string
    voteCount = json[SerializationKeys.voteCount].int
    overview = json[SerializationKeys.overview].string
    originalTitle = json[SerializationKeys.originalTitle].string
    voteAverage = json[SerializationKeys.voteAverage].int
    popularity = json[SerializationKeys.popularity].float
    id = json[SerializationKeys.id].int
    originalLanguage = json[SerializationKeys.originalLanguage].string
    releaseDate = json[SerializationKeys.releaseDate].string
    video = json[SerializationKeys.video].boolValue
    title = json[SerializationKeys.title].string
    mediaType = json[SerializationKeys.mediaType].string
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = posterPath { dictionary[SerializationKeys.posterPath] = value }
    if let value = originCountry { dictionary[SerializationKeys.originCountry] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    dictionary[SerializationKeys.adult] = adult
    if let value = genreIds { dictionary[SerializationKeys.genreIds] = value }
    if let value = firstAirDate { dictionary[SerializationKeys.firstAirDate] = value }
    if let value = originalName { dictionary[SerializationKeys.originalName] = value }
    if let value = voteCount { dictionary[SerializationKeys.voteCount] = value }
    if let value = overview { dictionary[SerializationKeys.overview] = value }
    if let value = originalTitle { dictionary[SerializationKeys.originalTitle] = value }
    if let value = voteAverage { dictionary[SerializationKeys.voteAverage] = value }
    if let value = popularity { dictionary[SerializationKeys.popularity] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = originalLanguage { dictionary[SerializationKeys.originalLanguage] = value }
    if let value = releaseDate { dictionary[SerializationKeys.releaseDate] = value }
    dictionary[SerializationKeys.video] = video
    if let value = title { dictionary[SerializationKeys.title] = value }
    if let value = mediaType { dictionary[SerializationKeys.mediaType] = value }
    return dictionary
  }

}
