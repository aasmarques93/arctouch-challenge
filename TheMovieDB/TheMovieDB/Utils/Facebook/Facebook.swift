//
//  Facebook.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/12/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
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
    static var shared = Facebook()
    
    lazy var parametersEmail = ["fields": "email"]
    lazy var parametersDetails = ["fields": "id, first_name, last_name, name, email, picture.type(large)"]
    lazy var readPermissions = ["public_profile", "email", "user_friends"]
    
    lazy var currentUserUrlPicture = ""
    
    func graphRequest(paths: [FacebookGraphPath],
                      parameters: [FacebookGraphParameters] = [.id, .name, .email, .picture],
                      handler: @escaping FBSDKGraphRequestHandler) {
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
            
            handler(connection, result, error)
        }
    }
}
