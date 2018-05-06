//
//  Model.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 01/02/17.
//  Copyright © 2017 Arthur Augusto Sousa Marques. All rights reserved.
//

import SwiftyJSON

protocol Model {
    var json: JSON? { get }
    init(object: Any)
    init(json: JSON?)
    func saveUserDefaults(name: String)
}

extension Model {
    var statusMessage: String? {
        if let json = json {
            return json["status_message"].string
        }
        return nil
    }
    
    func saveUserDefaults(name: String) {
        if let json = json { UserDefaults.standard.set(json.description, forKey: name) }
    }
}
