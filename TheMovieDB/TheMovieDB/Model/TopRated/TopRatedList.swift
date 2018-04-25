//
//  TopRatedList.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class TopRatedList: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let totalResults = "total_results"
    static let page = "page"
    static let results = "results"
    static let totalPages = "total_pages"
  }

  // MARK: Properties
  public var totalResults: Int?
  public var page: Int?
  public var results: [Movie]?
  public var totalPages: Int?

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
    totalResults = json[SerializationKeys.totalResults].int
    page = json[SerializationKeys.page].int
    if let items = json[SerializationKeys.results].array { results = items.map { Movie(json: $0) } }
    totalPages = json[SerializationKeys.totalPages].int
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = totalResults { dictionary[SerializationKeys.totalResults] = value }
    if let value = page { dictionary[SerializationKeys.page] = value }
    if let value = results { dictionary[SerializationKeys.results] = value.map { $0.dictionaryRepresentation() } }
    if let value = totalPages { dictionary[SerializationKeys.totalPages] = value }
    return dictionary
  }

}
