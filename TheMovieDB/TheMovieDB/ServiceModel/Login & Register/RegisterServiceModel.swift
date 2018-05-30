//
//  RegisterServiceModel.swift
//  Figurinhas
//
//  Created by Arthur Augusto Sousa Marques on 4/4/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct RegisterServiceModel {
    let serviceModel = Singleton.shared.serviceModel
    
    func signup(username: String? = nil,
                email: String? = nil,
                password: String? = nil,
                name: String? = nil,
                facebookId: String? = nil,
                handler: @escaping Handler<User>) {
        
        var parameters = [String: Any]()
        
        if let value = username { parameters["username"] = value }
        if let value = email { parameters["email"] = value }
        if let value = password { parameters["password"] = value }
        if let value = name { parameters["username"] = value }
        if let value = facebookId { parameters["facebookId"] = value }
        
        let urlParameters = ["language": Locale.preferredLanguages.first ?? ""]
        
        serviceModel.request(method: .post,
                             requestUrl: .register,
                             environmentBase: .heroku,
                             parameters: parameters,
                             urlParameters: urlParameters,
                             handlerObject: { (object) in
                                
                                guard let object = object else {
                                    return
                                }
                                handler(User(object: object))
        })
    }
}
