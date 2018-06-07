//
//  Facebook.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/12/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import FBSDKCoreKit

enum FacebookGraphPath: String {
    case me = "me"
    case friends = "me/friends"
    case userId
}

enum FacebookGraphParameters: String {
    case id = "id"
    case name = "name"
    case email = "email"
    case picture = "picture.type(large)"
}

struct Facebook {
    static var readPermissions = ["public_profile", "email", "user_friends"]
        
    static func graphRequest(paths: [FacebookGraphPath],
                             parameters: [FacebookGraphParameters] = [.id, .name, .email, .picture],
                             handler: @escaping HandlerObject) {
        var graphPath = ""
        
        var i = 0
        paths.forEach { (path) in
            graphPath += path.rawValue
            
            if i < paths.count-1 { graphPath += "," }
            
            i += 1
        }
        
        var stringParameters = ""
        var count = 0
        parameters.forEach { (param) in
            stringParameters += param.rawValue
            if count < parameters.count-1 { stringParameters += "," }
            count += 1
        }
        
        FBSDKGraphRequest(graphPath: graphPath, parameters: ["fields": stringParameters]).start { (connection, result, error) in
            if let error = error {
                print("Facebook Error: \(error)")
            }
            
            print("Facebook Result: \(result ?? "")")
            handler(result)
        }
    }
    
    static func getUserLogged(handler: @escaping Handler<User>) {
        graphRequest(paths: [.me]) { (result) in
            guard let result = result as? [String: Any] else {
                return
            }
            
            var dictionary = result
            dictionary[User.SerializationKeys.facebookId] = result["id"]
            dictionary["id"] = ""
            
            handler(User(object: dictionary))
        }
    }
    
    static func getUserFriends(handler: @escaping Handler<[User]>) {
        Facebook.graphRequest(paths: [.friends], parameters: [.id, .name, .picture]) { (result) in
            guard let result = result as? [String: Any], let data = result["data"] as? [Any] else {
                return
            }
            
            var arrayUserFriends = [User]()
            data.forEach({ (object) in
                guard let result = object as? [String: Any] else {
                    return
                }
                var dictionary = result
                dictionary[User.SerializationKeys.facebookId] = result["id"]
                dictionary["id"] = ""
                arrayUserFriends.append(User(object: dictionary))
            })
            
            handler(arrayUserFriends)
        }
    }
}
