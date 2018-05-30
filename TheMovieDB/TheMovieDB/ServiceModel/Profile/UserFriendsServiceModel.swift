//
//  UserFriendsServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/22/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import SwiftyJSON

struct UserFriendsServiceModel {
    var serviceModel: ServiceModel {
        return Singleton.shared.serviceModel
    }
 
    func getProfile(facebookId: String?, handler: @escaping Handler<User>) {
        let urlParameters = ["facebookId": facebookId ?? ""]
        
        serviceModel.request(requestUrl: .profileByFacebookId,
                             environmentBase: .heroku,
                             urlParameters: urlParameters,
                             handlerObject: { (object) in
                                
                                guard let object = object else {
                                    return
                                }
                                handler(User(object: object))
        })
    }
    
    func userFriendsProfiles(_ users: [User], handler: @escaping Handler<[User]>) {
        var parameters = [String: Any]()
        
        var array = [[String: Any]]()
        
        users.forEach { (user) in
            guard let value = user.facebookId else {
                return
            }
            array.append([User.SerializationKeys.facebookId: value])
        }
        
        parameters["userFriends"] = array
        
        serviceModel.request(method: .post,
                             requestUrl: .userFriendsProfiles,
                             environmentBase: .heroku,
                             parameters: parameters,
                             handlerObject: { (object) in
                                guard let array = object as? [JSON] else {
                                    return
                                }
                                
                                var arrayUsers = [User]()
                                array.forEach({ (data) in
                                    arrayUsers.append(User(object: data))
                                })
                                
                                handler(arrayUsers)
        })
    }    
}
