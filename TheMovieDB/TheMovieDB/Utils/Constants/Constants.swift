//
//  Constants.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

struct Constants {
    static let shared = Constants()
    
    let defaultDateFormat = "dd/MM/yyyy"
    let dateFormatIsoTime = "yyyy-MM-dd'T'hh:ss:mm"
}

enum Titles: String {
    // Button Common Titles
    case done = "OK"
    
    // Titles
    case movies = "Movies"
    case tvShows = "TV Shows"
    case popularPeople = "Popular people"
    case search = "Search"
}
