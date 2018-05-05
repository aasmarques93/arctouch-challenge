//
//  PersonServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct PersonServiceModel {
    let serviceModel = ServiceModel()
    
    func getPerson(from idPerson: Int?, requestUrl: RequestUrl, handler: @escaping HandlerObject) {
        let parameters = ["idPerson": idPerson ?? 0]
        serviceModel.request(requestUrl: requestUrl, urlParameters: parameters, handlerObject: { (object) in
            if let object = object {
                switch requestUrl {
                    case .person: handler(Person(object: object))
                    case .personMovieCredits: handler(CreditsList(object: object))
                    case .personExternalIds: handler(ExternalIds(object: object))
                default: break
                }
            }
        })
    }
    
    func loadImage(path: String?, handlerData: @escaping HandlerObject) {
        serviceModel.loadImage(path: path, handlerData: handlerData)
    }
}
