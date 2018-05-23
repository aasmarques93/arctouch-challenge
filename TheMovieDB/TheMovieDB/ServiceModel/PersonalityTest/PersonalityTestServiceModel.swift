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
    
    func save(personalityType: PersonalityType,
              comedyPercentage: Float?,
              actionPercentage: Float?,
              dramaPercentage: Float?,
              thrillerPercentage: Float?,
              documentaryPercentage: Float?,
              handler: HandlerObject? = nil) {
        
        var parameters = [String: Any]()
        
        if let value = personalityType.id { parameters["personalityTypeId"] = value }
        if let value = personalityType.title { parameters["title"] = value }
        if let value = personalityType.color { parameters["color"] = value }
        if let value = personalityType.text { parameters["text"] = value }
        if let value = comedyPercentage { parameters["comedyPercentage"] = value }
        if let value = actionPercentage { parameters["actionPercentage"] = value }
        if let value = dramaPercentage { parameters["dramaPercentage"] = value }
        if let value = thrillerPercentage { parameters["thrillerPercentage"] = value }
        if let value = documentaryPercentage { parameters["documentaryPercentage"] = value }
        
        serviceModel.request(method: .post,
                             requestUrl: .savePersonalityTest,
                             environmentBase: .heroku,
                             parameters: parameters,
                             handlerObject: { (object) in
                                
                                if let object = object { handler?(User(object: object)) }
        })
    }
}
