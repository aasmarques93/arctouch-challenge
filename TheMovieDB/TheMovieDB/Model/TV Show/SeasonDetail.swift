//
//  SeasonDetail.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/30/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct SeasonDetail: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let posterPath = "poster_path"
        static let overview = "overview"
        static let airDate = "air_date"
        static let id = "id"
        static let episodes = "episodes"
        static let name = "name"
        static let seasonNumber = "season_number"
    }
    
    // MARK: Properties
    var posterPath: String?
    var overview: String?
    var airDate: String?
    var id: Int?
    var episodes: [Episodes]?
    var name: String?
    var seasonNumber: Int?
    
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
        posterPath = json?[SerializationKeys.posterPath].string
        overview = json?[SerializationKeys.overview].string
        airDate = json?[SerializationKeys.airDate].string
        id = json?[SerializationKeys.id].int
        if let items = json?[SerializationKeys.episodes].array { episodes = items.map { Episodes(json: $0) } }
        name = json?[SerializationKeys.name].string
        seasonNumber = json?[SerializationKeys.seasonNumber].int
        
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = posterPath { dictionary[SerializationKeys.posterPath] = value }
        if let value = overview { dictionary[SerializationKeys.overview] = value }
        if let value = airDate { dictionary[SerializationKeys.airDate] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = episodes { dictionary[SerializationKeys.episodes] = value.map { $0.dictionaryRepresentation() } }
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = seasonNumber { dictionary[SerializationKeys.seasonNumber] = value }
        return dictionary
    }
}
