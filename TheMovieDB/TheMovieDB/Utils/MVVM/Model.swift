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
    func saveUserDefaults(key: String)
}

extension Model {
    var statusMessage: String? {
        if let json = json {
            return json["status_message"].string
        }
        return nil
    }
    
    func saveUserDefaults(key: String) {
        UserDefaultsWrapper.saveUserDefaults(object: self, key: key)
    }
}

struct UserDefaultsWrapper {
    static func saveUserDefaults(object: Model, key: String) {
        guard let json = object.json else {
            return
        }
        UserDefaults.standard.set(json.description, forKey: key)
    }
    
    static func fetchUserDefaults(key: String) -> Any? {
        guard let object = UserDefaults.standard.object(forKey: key) else {
            return nil
        }
        return object
    }
}
