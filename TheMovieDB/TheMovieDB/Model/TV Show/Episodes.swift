//
//  Episodes.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/30/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Episodes: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let overview = "overview"
    static let airDate = "air_date"
    static let crew = "crew"
    static let name = "name"
    static let id = "id"
    static let voteAverage = "vote_average"
    static let stillPath = "still_path"
    static let voteCount = "vote_count"
    static let productionCode = "production_code"
    static let episodeNumber = "episode_number"
    static let seasonNumber = "season_number"
    static let guestStars = "guest_stars"
  }

  // MARK: Properties
  public var overview: String?
  public var airDate: String?
  public var crew: [Crew]?
  public var name: String?
  public var id: Int?
  public var voteAverage: Float?
  public var stillPath: String?
  public var voteCount: Int?
  public var productionCode: String?
  public var episodeNumber: Int?
  public var seasonNumber: Int?
  public var guestStars: [GuestStars]?

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
    overview = json[SerializationKeys.overview].string
    airDate = json[SerializationKeys.airDate].string
    if let items = json[SerializationKeys.crew].array { crew = items.map { Crew(json: $0) } }
    name = json[SerializationKeys.name].string
    id = json[SerializationKeys.id].int
    voteAverage = json[SerializationKeys.voteAverage].float
    stillPath = json[SerializationKeys.stillPath].string
    voteCount = json[SerializationKeys.voteCount].int
    productionCode = json[SerializationKeys.productionCode].string
    episodeNumber = json[SerializationKeys.episodeNumber].int
    seasonNumber = json[SerializationKeys.seasonNumber].int
    if let items = json[SerializationKeys.guestStars].array { guestStars = items.map { GuestStars(json: $0) } }
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = overview { dictionary[SerializationKeys.overview] = value }
    if let value = airDate { dictionary[SerializationKeys.airDate] = value }
    if let value = crew { dictionary[SerializationKeys.crew] = value.map { $0.dictionaryRepresentation() } }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = voteAverage { dictionary[SerializationKeys.voteAverage] = value }
    if let value = stillPath { dictionary[SerializationKeys.stillPath] = value }
    if let value = voteCount { dictionary[SerializationKeys.voteCount] = value }
    if let value = productionCode { dictionary[SerializationKeys.productionCode] = value }
    if let value = episodeNumber { dictionary[SerializationKeys.episodeNumber] = value }
    if let value = seasonNumber { dictionary[SerializationKeys.seasonNumber] = value }
    if let value = guestStars { dictionary[SerializationKeys.guestStars] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
