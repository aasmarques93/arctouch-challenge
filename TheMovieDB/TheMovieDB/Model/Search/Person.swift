//
//  Person.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Person: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let profilePath = "profile_path"
    static let alsoKnownAs = "also_known_as"
    static let gender = "gender"
    static let birthday = "birthday"
    static let placeOfBirth = "place_of_birth"
    static let popularity = "popularity"
    static let id = "id"
    static let biography = "biography"
    static let imdbId = "imdb_id"
    static let adult = "adult"
    static let movies = "known_for"
  }

  // MARK: Properties
  public var name: String?
  public var profilePath: String?
  public var alsoKnownAs: [String]?
  public var gender: Int?
  public var birthday: String?
  public var placeOfBirth: String?
  public var popularity: Float?
  public var id: Int?
  public var biography: String?
  public var imdbId: String?
  public var adult: Bool? = false
  public var movies: [Movie]?
    
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
    profilePath = json[SerializationKeys.profilePath].string
    if let items = json[SerializationKeys.alsoKnownAs].array { alsoKnownAs = items.map { $0.stringValue } }
    gender = json[SerializationKeys.gender].int
    birthday = json[SerializationKeys.birthday].string
    placeOfBirth = json[SerializationKeys.placeOfBirth].string
    popularity = json[SerializationKeys.popularity].float
    id = json[SerializationKeys.id].int
    biography = json[SerializationKeys.biography].string
    imdbId = json[SerializationKeys.imdbId].string
    adult = json[SerializationKeys.adult].boolValue
    if let items = json[SerializationKeys.movies].array { movies = items.map { Movie(json: $0) } }
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = profilePath { dictionary[SerializationKeys.profilePath] = value }
    if let value = alsoKnownAs { dictionary[SerializationKeys.alsoKnownAs] = value }
    if let value = gender { dictionary[SerializationKeys.gender] = value }
    if let value = birthday { dictionary[SerializationKeys.birthday] = value }
    if let value = placeOfBirth { dictionary[SerializationKeys.placeOfBirth] = value }
    if let value = popularity { dictionary[SerializationKeys.popularity] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = biography { dictionary[SerializationKeys.biography] = value }
    if let value = imdbId { dictionary[SerializationKeys.imdbId] = value }
    if let value = movies { dictionary[SerializationKeys.movies] = value.map { $0.dictionaryRepresentation() } }
    dictionary[SerializationKeys.adult] = adult
    return dictionary
  }

}
