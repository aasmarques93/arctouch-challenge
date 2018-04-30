//
//  Results.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class Review: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let content = "content"
    static let author = "author"
    static let id = "id"
    static let url = "url"
  }

  // MARK: Properties
  public var content: String?
  public var author: String?
  public var id: String?
  public var url: String?

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
    content = json[SerializationKeys.content].string
    author = json[SerializationKeys.author].string
    id = json[SerializationKeys.id].string
    url = json[SerializationKeys.url].string
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = content { dictionary[SerializationKeys.content] = value }
    if let value = author { dictionary[SerializationKeys.author] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = url { dictionary[SerializationKeys.url] = value }
    return dictionary
  }

}
