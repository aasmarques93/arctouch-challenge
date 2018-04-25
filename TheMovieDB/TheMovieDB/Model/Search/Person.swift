//
//  Results.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Person: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let popularity = "popularity"
    static let id = "id"
    static let movies = "known_for"
    static let adult = "adult"
  }

  // MARK: Properties
  public var name: String?
  public var popularity: Float?
  public var idPerson: Int?
  public var movies: [Movie]?
  public var adult: Bool? = false

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
    name = json[SerializationKeys.name].string
    popularity = json[SerializationKeys.popularity].float
    idPerson = json[SerializationKeys.id].int
    if let items = json[SerializationKeys.movies].array { movies = items.map { Movie(json: $0) } }
    adult = json[SerializationKeys.adult].boolValue
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = popularity { dictionary[SerializationKeys.popularity] = value }
    if let value = idPerson { dictionary[SerializationKeys.id] = value }
    if let value = movies { dictionary[SerializationKeys.movies] = value.map { $0.dictionaryRepresentation() } }
    dictionary[SerializationKeys.adult] = adult
    return dictionary
  }

}
