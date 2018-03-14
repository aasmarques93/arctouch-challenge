//
//  ProductionCountries.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class ProductionCountries: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let iso31661 = "iso_3166_1"
  }

  // MARK: Properties
  public var name: String?
  public var iso31661: String?

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
    iso31661 = json[SerializationKeys.iso31661].string
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = iso31661 { dictionary[SerializationKeys.iso31661] = value }
    return dictionary
  }

}
