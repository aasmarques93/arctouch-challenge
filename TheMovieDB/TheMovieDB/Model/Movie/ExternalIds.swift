//
//  ExternalId.swift
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct ExternalIds: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let id = "id"
        static let freebaseId = "freebase_id"
        static let imdbId = "imdb_id"
        static let instagramId = "instagram_id"
        static let freebaseMid = "freebase_mid"
        static let tvrageId = "tvrage_id"
        static let facebookId = "facebook_id"
        static let twitterId = "twitter_id"
    }
    
    // MARK: Properties
    var id: Int?
    var freebaseId: String?
    var imdbId: String?
    var instagramId: String?
    var freebaseMid: String?
    var tvrageId: Int?
    var facebookId: String?
    var twitterId: String?
    
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
        id = json?[SerializationKeys.id].int
        freebaseId = json?[SerializationKeys.freebaseId].string
        imdbId = json?[SerializationKeys.imdbId].string
        instagramId = json?[SerializationKeys.instagramId].string
        freebaseMid = json?[SerializationKeys.freebaseMid].string
        tvrageId = json?[SerializationKeys.tvrageId].int
        facebookId = json?[SerializationKeys.facebookId].string
        twitterId = json?[SerializationKeys.twitterId].string
        
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = freebaseId { dictionary[SerializationKeys.freebaseId] = value }
        if let value = imdbId { dictionary[SerializationKeys.imdbId] = value }
        if let value = instagramId { dictionary[SerializationKeys.instagramId] = value }
        if let value = freebaseMid { dictionary[SerializationKeys.freebaseMid] = value }
        if let value = tvrageId { dictionary[SerializationKeys.tvrageId] = value }
        if let value = facebookId { dictionary[SerializationKeys.facebookId] = value }
        if let value = twitterId { dictionary[SerializationKeys.twitterId] = value }
        return dictionary
    }
}
