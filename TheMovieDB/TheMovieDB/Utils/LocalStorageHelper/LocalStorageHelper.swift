//
//  LocalStorageHelper.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/9/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import SwiftKeychainWrapper

enum LocalStorageKeys {
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

struct LocalStorageHelper {
    static func save(object: Any?, key: LocalStorageKeys) {
        guard let object = object else {
            return
        }
        _ = KeychainWrapper.standard.set(NSKeyedArchiver.archivedData(withRootObject: object), forKey: key.description)
    }
    
    static func fetch(key: LocalStorageKeys) -> Any? {
        guard let data = KeychainWrapper.standard.data(forKey: key.description) else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
    
    static func delete(key: LocalStorageKeys) {
        _ = KeychainWrapper.standard.removeObject(forKey: key.description)
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
