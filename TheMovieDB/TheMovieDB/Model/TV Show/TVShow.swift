//
//  Results.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class TVShow: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
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
  }

  // MARK: Properties
  public var originCountry: [String]?
  public var name: String?
  public var genreIds: [Int]?
  public var firstAirDate: String?
  public var originalName: String?
  public var voteCount: Int?
  public var overview: String?
  public var popularity: Float?
  public var voteAverage: Int?
  public var id: Int?
  public var originalLanguage: String?
  public var posterPath: String?

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
    if let items = json[SerializationKeys.originCountry].array { originCountry = items.map { $0.stringValue } }
    name = json[SerializationKeys.name].string
    if let items = json[SerializationKeys.genreIds].array { genreIds = items.map { $0.intValue } }
    firstAirDate = json[SerializationKeys.firstAirDate].string
    originalName = json[SerializationKeys.originalName].string
    voteCount = json[SerializationKeys.voteCount].int
    overview = json[SerializationKeys.overview].string
    popularity = json[SerializationKeys.popularity].float
    voteAverage = json[SerializationKeys.voteAverage].int
    id = json[SerializationKeys.id].int
    originalLanguage = json[SerializationKeys.originalLanguage].string
    posterPath = json[SerializationKeys.posterPath].string
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
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
    return dictionary
  }

}
