//
//  BelongsToCollection.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class BelongsToCollection: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let posterPath = "poster_path"
    static let name = "name"
    static let backdropPath = "backdrop_path"
    static let id = "id"
  }

  // MARK: Properties
  public var posterPath: String?
  public var name: String?
  public var backdropPath: String?
  public var id: Int?

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
    name = json[SerializationKeys.name].string
    backdropPath = json[SerializationKeys.backdropPath].string
    id = json[SerializationKeys.id].int
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = posterPath { dictionary[SerializationKeys.posterPath] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = backdropPath { dictionary[SerializationKeys.backdropPath] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    return dictionary
  }

}
