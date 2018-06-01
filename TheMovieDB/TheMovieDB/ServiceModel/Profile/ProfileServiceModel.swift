//
//  ProfileServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/22/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct ProfileServiceModel: ServiceModel {
    func getProfile(handler: @escaping Handler<User>) {
        request(requestUrl: .profile,
                environmentBase: .heroku,
                handlerObject: { (object) in
                    
                    guard let object = object else {
                        return
                    }
                    handler(User(object: object))
        })
    }
    
    func doLogout(handler: HandlerCallback? = nil) {
        request(requestUrl: .logout, environmentBase: .heroku, handlerObject: { (object) in
            handler?()
        })
    }
}
