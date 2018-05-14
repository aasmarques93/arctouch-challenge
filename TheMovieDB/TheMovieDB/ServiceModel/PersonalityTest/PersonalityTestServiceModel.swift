//
//  PersonalityTestServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/11/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

struct PersonalityTestServiceModel {
    let serviceModel = Singleton.shared.serviceModel
    
    func getPersonality(requestUrl: RequestUrl, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: requestUrl, environmentBase: .heroku, handlerObject: { (object) in
            if let object = object { handler(Personality(object: object)) }
        })
    }
}
