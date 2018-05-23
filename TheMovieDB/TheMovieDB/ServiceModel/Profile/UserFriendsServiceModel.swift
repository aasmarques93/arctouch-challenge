//
//  UserFriendsServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/22/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

struct UserFriendsServiceModel {
    var serviceModel: ServiceModel {
        return Singleton.shared.serviceModel
    }
 
    func getProfile(facebookId: String?, handler: @escaping HandlerObject) {
        let urlParameters = ["facebookId": facebookId ?? ""]
        
        serviceModel.request(requestUrl: .profileByFacebookId,
                             environmentBase: .heroku,
                             urlParameters: urlParameters,
                             handlerObject: { (object) in
                                
                                if let object = object { handler(User(object: object)) }
        })
    }
    
    func loadImage(path: String?, handlerData: @escaping HandlerObject) {
        serviceModel.loadImage(path: path, environmentBase: .custom, handlerData: handlerData)
    }
}
