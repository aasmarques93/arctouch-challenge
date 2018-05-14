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
    
    case netflixMovies = "Netflix Movies"
    
    // Fabric
    case error = "Error"
    case click = "Click"
    case event = "Event"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
