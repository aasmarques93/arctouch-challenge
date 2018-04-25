//
//  EnvironmentRequest.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Foundation

// MARK: - File Names -
struct FileName {
    static let requestUrl = "RequestLinks"
    static let environmentLink = "EnvironmentLinks"
}

class EnvironmentHost {
    static let shared = EnvironmentHost()
    
    var current: EnvironmentBase = .api
    
    var host: String {
        let file = FileManager.load(name: FileName.environmentLink)
        if let host = file?.object(forKey: current.rawValue) as? String {
            return host
        }
        return ""
    }
}

// MARK: - Environment Base Enum -
enum EnvironmentBase: String {
    case api
    case images
}

// MARK: - Request Link Enum -
enum RequestUrl: String {
    case apiKey
    case nowPlaying
    case upcoming
    case topRated
    case popular
    case movie
    case videos
    case recommendations
    case similar
    case searchMovie
    case searchPerson
    case searchByGenre
    case genres
}
