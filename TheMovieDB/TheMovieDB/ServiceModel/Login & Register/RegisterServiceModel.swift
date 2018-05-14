//
//  RegisterServiceModel.swift
//  Figurinhas
//
//  Created by Arthur Augusto Sousa Marques on 4/4/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

struct RegisterServiceModel {
    let serviceModel = Singleton.shared.serviceModel
    
    func signup(username: String? = nil,
                email: String? = nil,
                password: String? = nil,
                facebookId: String? = nil,
                handlerObject: @escaping HandlerObject,
                handlerError: @escaping HandlerObject) {
        
//        var parameters = [String: Any]()
//        
//        if let value = username { parameters["name"] = value }
//        if let value = email { parameters["email"] = value }
//        if let value = password { parameters["password"] = value }
//        if let value = facebookId { parameters["facebook_id"] = value }
//        
//        request(User.self, method: .post, requestUrl: .signUp, parameters: parameters, handlerObject: { (object) in
//            if let user = object as? User {
//                if let error = user.error, !error.isEmptyOrWhitespace {
//                    handlerError(error)
//                } else {
//                    handlerObject(object)
//                    self.setConnectionHeader(token: user.token)
//                }
//                
//                return
//            }
//            
//            handlerError(Messages.serverError.rawValue)
//        })
    }
}

