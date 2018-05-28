//
//  Constants.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

struct Constants {
    static let defaultDateFormat = "dd/MM/yyyy"
    static let dateFormatIsoTime = "yyyy-MM-dd'T'hh:ss:mm"
}

enum Titles: String {
    // Button Common Titles
    case done = "OK"
    
    // Titles
    case personalityTest = "Personality Test"
    case personalityTestResult = "Personality Test Result"
    case youGot = "You got"
    case result = "Result"
    
    case movies = "Movies"
    case tvShows = "TV Shows"
    case popularPeople = "Popular people"
    case search = "Search"
    case profile = "Profile"
    
    case movie = "Movie"
    case tvShow = "TV Show"
    
    case netflixMovies = "Netflix Movies"
    case roulette = "Roulette"
    case filter = "Filter"
    case allGenres = "All Genres"
    case anyScore = "Any Score"
    
    case photos = "All photos"
    
    case trackTvShow = "Track TV Show"
    case episode = "Episode"
    case rate = "Rate"
    
    case wantToSeeMovies = "Want To See Movies"
    case tvShowsTrack = "TV Shows Track"
    case seenMovies = "Seen Movies"
    
    // Personality
    case comedy = "Comedy"
    case action = "Action"
    case drama = "Drama"
    case thriller = "Thriller"
    case documentary = "Documentary"
    
    // Fabric
    case error = "Error"
    case success = "Success"
    case click = "Click"
    case event = "Event"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
