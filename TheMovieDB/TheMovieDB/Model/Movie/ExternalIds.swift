//
//  ExternalId.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class ExternalIds: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let id = "id"
    static let freebaseId = "freebase_id"
    static let imdbId = "imdb_id"
    static let instagramId = "instagram_id"
    static let freebaseMid = "freebase_mid"
    static let tvrageId = "tvrage_id"
    static let facebookId = "facebook_id"
    static let twitterId = "twitter_id"
  }

  // MARK: Properties
  public var id: Int?
  public var freebaseId: String?
  public var imdbId: String?
  public var instagramId: String?
  public var freebaseMid: String?
  public var tvrageId: Int?
  public var facebookId: String?
  public var twitterId: String?

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
    id = json[SerializationKeys.id].int
    freebaseId = json[SerializationKeys.freebaseId].string
    imdbId = json[SerializationKeys.imdbId].string
    instagramId = json[SerializationKeys.instagramId].string
    freebaseMid = json[SerializationKeys.freebaseMid].string
    tvrageId = json[SerializationKeys.tvrageId].int
    facebookId = json[SerializationKeys.facebookId].string
    twitterId = json[SerializationKeys.twitterId].string
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = freebaseId { dictionary[SerializationKeys.freebaseId] = value }
    if let value = imdbId { dictionary[SerializationKeys.imdbId] = value }
    if let value = instagramId { dictionary[SerializationKeys.instagramId] = value }
    if let value = freebaseMid { dictionary[SerializationKeys.freebaseMid] = value }
    if let value = tvrageId { dictionary[SerializationKeys.tvrageId] = value }
    if let value = facebookId { dictionary[SerializationKeys.facebookId] = value }
    if let value = twitterId { dictionary[SerializationKeys.twitterId] = value }
    return dictionary
  }

}
