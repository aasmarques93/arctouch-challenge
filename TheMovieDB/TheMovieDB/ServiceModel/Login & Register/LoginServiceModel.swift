//
//  LoginServiceModel.swift
//  Figurinhas
//
//  Created by Arthur Augusto Sousa Marques on 3/22/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct LoginServiceModel: ServiceModel {
    func authenticate(userId: String? = nil,
                      email: String? = nil,
                      password: String? = nil,
                      facebookId: String? = nil,
                      handler: @escaping Handler<User>) {
        
        var parameters = [String: Any]()
        
        if let value = userId { parameters["userId"] = value }
        if let value = email { parameters["email"] = value }
        if let value = password { parameters["password"] = value }
        if let value = facebookId { parameters["facebookId"] = value }
        
        let urlParameters = ["language": Locale.preferredLanguages.first ?? ""]
        
        request(method: .post,
                requestUrl: .authenticate,
                environmentBase: .heroku,
                parameters: parameters,
                urlParameters: urlParameters,
                handlerObject: { (object) in
                    
                    guard let object = object else {
                        handler(User.handleError())
                        return
                    }
                    
                    handler(User(object: object))
        })
    }
    
    func recoverPassword(email: String, handlerObject: HandlerObject, handlerError: HandlerObject? = nil) {
        
    }
}
