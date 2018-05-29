//
//  ProfileServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/22/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct ProfileServiceModel {
    var serviceModel: ServiceModel {
        return Singleton.shared.serviceModel
    }
    
    func getProfile(handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .profile,
                             environmentBase: .heroku,
                             handlerObject: { (object) in
                                
                                guard let object = object else {
                                    return
                                }
                                handler(User(object: object))
        })
    }
    
    func doLogout(handler: HandlerObject? = nil) {
        serviceModel.request(requestUrl: .logout, environmentBase: .heroku, handlerObject: { (object) in
            handler?(object)
        })
    }
}
