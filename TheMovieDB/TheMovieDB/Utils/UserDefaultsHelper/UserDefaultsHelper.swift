//
//  UserDefaultsHelper.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/9/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

enum UserDefaultsKeys {
    case appOpenedCount
    case answeredQuestions
    case didSkipTest
    case userPersonality
    case userLogged
    case custom(String)
    
    var description: String {
        return "\(self)"
    }
}

struct UserDefaultsHelper {
    static func saveUserDefaults(object: Any?, key: UserDefaultsKeys) {
        guard let object = object else {
            return
        }
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: object), forKey: key.description)
    }
    
    static func fetchUserDefaults(key: UserDefaultsKeys) -> Any? {
        guard let data = UserDefaults.standard.object(forKey: key.description) as? Data else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
    
    static func getImagePath(with data: Data) -> String {
        if let string = String(data: data.base64EncodedData(), encoding: .utf8) {
            return string
        }
        return ""
    }
    
    static func getImageData(from path: String) -> Data? {
        return Data(base64Encoded: path)
    }
}
