//
//  CreatedBy.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class CreatedBy: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let gender = "gender"
    static let name = "name"
    static let profilePath = "profile_path"
    static let id = "id"
  }

  // MARK: Properties
  public var gender: Int?
  public var name: String?
  public var profilePath: String?
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
    gender = json[SerializationKeys.gender].int
    name = json[SerializationKeys.name].string
    profilePath = json[SerializationKeys.profilePath].string
    id = json[SerializationKeys.id].int
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = gender { dictionary[SerializationKeys.gender] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = profilePath { dictionary[SerializationKeys.profilePath] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    return dictionary
  }

}
