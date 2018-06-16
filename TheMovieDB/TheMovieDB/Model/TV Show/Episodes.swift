//
//  Episodes.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/30/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Episodes: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let overview = "overview"
        static let airDate = "air_date"
        static let crew = "crew"
        static let name = "name"
        static let id = "id"
        static let voteAverage = "vote_average"
        static let stillPath = "still_path"
        static let voteCount = "vote_count"
        static let productionCode = "production_code"
        static let episodeNumber = "episode_number"
        static let seasonNumber = "season_number"
        static let guestStars = "guest_stars"
    }
    
    // MARK: Properties
    var overview: String?
    var airDate: String?
    var crew: [Crew]?
    var name: String?
    var id: Int?
    var voteAverage: Float?
    var stillPath: String?
    var voteCount: Int?
    var productionCode: String?
    var episodeNumber: Int?
    var seasonNumber: Int?
    var guestStars: [GuestStars]?
    
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
        overview = json?[SerializationKeys.overview].string
        airDate = json?[SerializationKeys.airDate].string
        if let items = json?[SerializationKeys.crew].array { crew = items.map { Crew(json: $0) } }
        name = json?[SerializationKeys.name].string
        id = json?[SerializationKeys.id].int
        voteAverage = json?[SerializationKeys.voteAverage].float
        stillPath = json?[SerializationKeys.stillPath].string
        voteCount = json?[SerializationKeys.voteCount].int
        productionCode = json?[SerializationKeys.productionCode].string
        episodeNumber = json?[SerializationKeys.episodeNumber].int
        seasonNumber = json?[SerializationKeys.seasonNumber].int
        if let items = json?[SerializationKeys.guestStars].array { guestStars = items.map { GuestStars(json: $0) } }
        
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = overview { dictionary[SerializationKeys.overview] = value }
        if let value = airDate { dictionary[SerializationKeys.airDate] = value }
        if let value = crew { dictionary[SerializationKeys.crew] = value.map { $0.dictionaryRepresentation() } }
        if let value = name { dictionary[SerializationKeys.name] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = voteAverage { dictionary[SerializationKeys.voteAverage] = value }
        if let value = stillPath { dictionary[SerializationKeys.stillPath] = value }
        if let value = voteCount { dictionary[SerializationKeys.voteCount] = value }
        if let value = productionCode { dictionary[SerializationKeys.productionCode] = value }
        if let value = episodeNumber { dictionary[SerializationKeys.episodeNumber] = value }
        if let value = seasonNumber { dictionary[SerializationKeys.seasonNumber] = value }
        if let value = guestStars { dictionary[SerializationKeys.guestStars] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
}
