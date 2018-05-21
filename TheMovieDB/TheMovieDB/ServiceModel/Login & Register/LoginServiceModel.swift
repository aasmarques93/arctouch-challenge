//
//  LoginServiceModel.swift
//  Figurinhas
//
//  Created by Arthur Augusto Sousa Marques on 3/22/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

struct LoginServiceModel {
    let serviceModel = Singleton.shared.serviceModel
    
    func authenticate(userId: String? = nil,
                      email: String? = nil,
                      password: String? = nil,
                      facebookId: String? = nil,
                      handler: HandlerObject? = nil) {
        
        var parameters = [String: Any]()

        if let value = userId { parameters["userId"] = value }
        if let value = email { parameters["email"] = value }
        if let value = password { parameters["password"] = value }
        if let value = facebookId { parameters["facebook_id"] = value }

        let urlParameters = ["language": Locale.preferredLanguages.first ?? ""]
        
        serviceModel.request(method: .post,
                             requestUrl: .authenticate,
                             environmentBase: .heroku,
                             parameters: parameters,
                             urlParameters: urlParameters,
                             handlerObject: { (object) in
                                
                                if let object = object { handler?(User(object: object)) }
        })
    }
    
    func recoverPassword(email: String, handlerObject: HandlerObject, handlerError: HandlerObject? = nil) {
        
    }
    
    func loadImage(path: String?, handlerData: @escaping HandlerObject) {
        serviceModel.loadImage(path: path, handlerData: handlerData)
    }
}
