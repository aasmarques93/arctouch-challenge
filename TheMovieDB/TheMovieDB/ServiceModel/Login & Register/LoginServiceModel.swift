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
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
    }
    
    func authenticate(email: String? = nil,
                      password: String? = nil,
                      facebookId: String? = nil,
                      handlerObject: @escaping HandlerObject,
                      handlerError: @escaping HandlerObject) {
        
//        var parameters = [String: Any]()
//
//        if let value = email { parameters["email"] = value }
//        if let value = password { parameters["password"] = value }
//        if let value = facebookId { parameters["facebook_id"] = value }
//
//        request(User.self, method: .post, requestUrl: .authentication, parameters: parameters, handlerObject: { (object) in
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
    
    func recoverPassword(email: String, handlerObject: HandlerObject, handlerError: HandlerObject? = nil) {
        
    }
    
    func loadImage(path: String?, handlerData: @escaping HandlerObject) {
        serviceModel.loadImage(path: path, handlerData: handlerData)
    }
}
