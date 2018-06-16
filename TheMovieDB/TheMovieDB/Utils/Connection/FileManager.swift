//
//  FileManager.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Foundation

// MARK: - File Names -
enum FileManager: String {
    case requestLinks = "RequestLinks"
    case environmentLink = "EnvironmentLinks"
    
    static func load(file: FileManager, key: String) -> String {
        guard let host = file.contentDictionary?.object(forKey: key) as? String else {
            return ""
        }
        return host
    }
    
    var contentDictionary: NSMutableDictionary? {
        guard let bundle = Bundle.main.path(forResource: rawValue, ofType: "plist") else {
            return nil
        }
        return NSMutableDictionary(contentsOfFile: bundle)
    }
}

