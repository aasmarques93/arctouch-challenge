//
//  NetflixMovieShow.swift
//
//  Created by Arthur Augusto Sousa Marques on 5/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct NetflixMovieShow: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let hasBackdrop = "has_backdrop"
        static let watchlisted = "watchlisted"
        static let rtCriticsRating = "rt_critics_rating"
        static let genres = "genres"
        static let language = "language"
        static let tags = "tags"
        static let overview = "overview"
        static let hasPoster = "has_poster"
        static let runtime = "runtime"
        static let rtAudienceRating = "rt_audience_rating"
        static let slug = "slug"
        static let id = "id"
        static let releasedOn = "released_on"
        static let availability = "availability"
        static let seen = "seen"
        static let people = "people"
        static let title = "title"
        static let tagline = "tagline"
        static let trailer = "trailer"
        static let imdbRating = "imdb_rating"
    }
    
    // MARK: Properties
    var hasBackdrop: Bool? = false
    var watchlisted: Bool? = false
    var rtCriticsRating: Int?
    var genres: [Int]?
    var language: String?
    var tags: [Any]?
    var overview: String?
    var hasPoster: Bool? = false
    var runtime: Int?
    var rtAudienceRating: Int?
    var slug: String?
    var id: String?
    var releasedOn: String?
    var availability: [NetflixAvailability]?
    var seen: Bool? = false
    var people: [NetflixPeople]?
    var title: String?
    var tagline: String?
    var trailer: NetflixTrailer?
    var imdbRating: Float?
    
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
        hasBackdrop = json?[SerializationKeys.hasBackdrop].boolValue
        watchlisted = json?[SerializationKeys.watchlisted].boolValue
        rtCriticsRating = json?[SerializationKeys.rtCriticsRating].int
        if let items = json?[SerializationKeys.genres].array { genres = items.map { $0.intValue } }
        language = json?[SerializationKeys.language].string
        if let items = json?[SerializationKeys.tags].array { tags = items.map { $0.object} }
        overview = json?[SerializationKeys.overview].string
        hasPoster = json?[SerializationKeys.hasPoster].boolValue
        runtime = json?[SerializationKeys.runtime].int
        rtAudienceRating = json?[SerializationKeys.rtAudienceRating].int
        slug = json?[SerializationKeys.slug].string
        id = json?[SerializationKeys.id].string
        releasedOn = json?[SerializationKeys.releasedOn].string
        if let items = json?[SerializationKeys.availability].array { availability = items.map { NetflixAvailability(json: $0) } }
        seen = json?[SerializationKeys.seen].boolValue
        if let items = json?[SerializationKeys.people].array { people = items.map { NetflixPeople(json: $0) } }
        title = json?[SerializationKeys.title].string
        tagline = json?[SerializationKeys.tagline].string
        trailer = NetflixTrailer(json: json?[SerializationKeys.trailer])
        imdbRating = json?[SerializationKeys.imdbRating].float
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[SerializationKeys.hasBackdrop] = hasBackdrop
        dictionary[SerializationKeys.watchlisted] = watchlisted
        if let value = rtCriticsRating { dictionary[SerializationKeys.rtCriticsRating] = value }
        if let value = genres { dictionary[SerializationKeys.genres] = value }
        if let value = language { dictionary[SerializationKeys.language] = value }
        if let value = tags { dictionary[SerializationKeys.tags] = value }
        if let value = overview { dictionary[SerializationKeys.overview] = value }
        dictionary[SerializationKeys.hasPoster] = hasPoster
        if let value = runtime { dictionary[SerializationKeys.runtime] = value }
        if let value = rtAudienceRating { dictionary[SerializationKeys.rtAudienceRating] = value }
        if let value = slug { dictionary[SerializationKeys.slug] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = releasedOn { dictionary[SerializationKeys.releasedOn] = value }
        if let value = availability { dictionary[SerializationKeys.availability] = value.map { $0.dictionaryRepresentation() } }
        dictionary[SerializationKeys.seen] = seen
        if let value = people { dictionary[SerializationKeys.people] = value.map { $0.dictionaryRepresentation() } }
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = tagline { dictionary[SerializationKeys.tagline] = value }
        if let value = trailer { dictionary[SerializationKeys.trailer] = value.dictionaryRepresentation() }
        if let value = imdbRating { dictionary[SerializationKeys.imdbRating] = value }
        return dictionary
    }
    
}
