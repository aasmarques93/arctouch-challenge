//
//  SearchMoviesGenre.swift
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchMoviesGenre: Model {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let totalPages = "total_pages"
    static let page = "page"
    static let id = "id"
    static let results = "results"
    static let totalResults = "total_results"
  }

  // MARK: Properties
  public var totalPages: Int?
  public var page: Int?
  public var idSearch: Int?
  public var results: [Movie]?
  public var totalResults: Int?

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
    totalPages = json[SerializationKeys.totalPages].int
    page = json[SerializationKeys.page].int
    idSearch = json[SerializationKeys.id].int
    if let items = json[SerializationKeys.results].array { results = items.map { Movie(json: $0) } }
    totalResults = json[SerializationKeys.totalResults].int
    super.init(json: json)
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = totalPages { dictionary[SerializationKeys.totalPages] = value }
    if let value = page { dictionary[SerializationKeys.page] = value }
    if let value = idSearch { dictionary[SerializationKeys.id] = value }
    if let value = results { dictionary[SerializationKeys.results] = value.map { $0.dictionaryRepresentation() } }
    if let value = totalResults { dictionary[SerializationKeys.totalResults] = value }
    return dictionary
  }

}
