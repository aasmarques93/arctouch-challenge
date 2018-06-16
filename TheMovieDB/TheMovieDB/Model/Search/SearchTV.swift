//
//  SearchTV.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct SearchTV: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let totalResults = "total_results"
        static let page = "page"
        static let results = "results"
        static let totalPages = "total_pages"
    }
    
    // MARK: Properties
    var totalResults: Int?
    var page: Int?
    var results: [TVShow]?
    var totalPages: Int?
    
    // MARK: SwiftyJSON Initializers
    init(object: Any) {
        if let json = object as? JSON {
            self.init(json: json)
            return
        }
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    init(json: JSON?) {
        self.json = json
        totalResults = json?[SerializationKeys.totalResults].int
        page = json?[SerializationKeys.page].int
        if let items = json?[SerializationKeys.results].array { results = items.map { TVShow(json: $0) } }
        totalPages = json?[SerializationKeys.totalPages].int
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = totalResults { dictionary[SerializationKeys.totalResults] = value }
        if let value = page { dictionary[SerializationKeys.page] = value }
        if let value = results { dictionary[SerializationKeys.results] = value.map { $0.dictionaryRepresentation() } }
        if let value = totalPages { dictionary[SerializationKeys.totalPages] = value }
        return dictionary
    }
}
