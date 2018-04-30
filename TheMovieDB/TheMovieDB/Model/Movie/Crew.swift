//
//  Crew.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Crew: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let profilePath = "profile_path"
    static let department = "department"
    static let id = "id"
    static let job = "job"
    static let gender = "gender"
    static let creditId = "credit_id"
  }

  // MARK: Properties
  public var name: String?
  public var profilePath: String?
  public var department: String?
  public var id: Int?
  public var job: String?
  public var gender: Int?
  public var creditId: String?

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
    department = json[SerializationKeys.department].string
    id = json[SerializationKeys.id].int
    job = json[SerializationKeys.job].string
    gender = json[SerializationKeys.gender].int
    creditId = json[SerializationKeys.creditId].string
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = profilePath { dictionary[SerializationKeys.profilePath] = value }
    if let value = department { dictionary[SerializationKeys.department] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = job { dictionary[SerializationKeys.job] = value }
    if let value = gender { dictionary[SerializationKeys.gender] = value }
    if let value = creditId { dictionary[SerializationKeys.creditId] = value }
    return dictionary
  }

}
