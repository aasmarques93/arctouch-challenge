//
//  SeasonDetail.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/30/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class SeasonDetail: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let posterPath = "poster_path"
    static let overview = "overview"
    static let airDate = "air_date"
    static let id = "id"
    static let episodes = "episodes"
    static let name = "name"
    static let seasonNumber = "season_number"
  }

  // MARK: Properties
  public var posterPath: String?
  public var overview: String?
  public var airDate: String?
  public var id: Int?
  public var episodes: [Episodes]?
  public var name: String?
  public var seasonNumber: Int?

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
    overview = json[SerializationKeys.overview].string
    airDate = json[SerializationKeys.airDate].string
    id = json[SerializationKeys.id].int
    if let items = json[SerializationKeys.episodes].array { episodes = items.map { Episodes(json: $0) } }
    name = json[SerializationKeys.name].string
    seasonNumber = json[SerializationKeys.seasonNumber].int
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = posterPath { dictionary[SerializationKeys.posterPath] = value }
    if let value = overview { dictionary[SerializationKeys.overview] = value }
    if let value = airDate { dictionary[SerializationKeys.airDate] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = episodes { dictionary[SerializationKeys.episodes] = value.map { $0.dictionaryRepresentation() } }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = seasonNumber { dictionary[SerializationKeys.seasonNumber] = value }
    return dictionary
  }

}
