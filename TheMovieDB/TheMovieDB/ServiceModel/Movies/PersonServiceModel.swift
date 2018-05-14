//
//  PersonServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct PersonServiceModel {
    let serviceModel = Singleton.shared.serviceModel
    
    func getPerson(from idPerson: Int?, requestUrl: RequestUrl, handler: @escaping HandlerObject) {
        let parameters: [String: Any] = [
            "idPerson": idPerson ?? 0,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        serviceModel.request(requestUrl: requestUrl, urlParameters: parameters, handlerObject: { (object) in
            if let object = object {
                switch requestUrl {
                case .person:
                    handler(Person(object: object))
                case .personMovieCredits:
                    handler(CreditsList(object: object))
                case .personExternalIds:
                    handler(ExternalIds(object: object))
                default:
                    break
                }
            }
        })
    }

    func getImages(from idPerson: Int?, handler: @escaping HandlerObject) {
        let parameters: [String: Any] = [
            "idPerson": idPerson ?? 0,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        serviceModel.request(requestUrl: .personImages, urlParameters: parameters, handlerObject: { (object) in
            if let object = object {
                handler(PersonImagesList(object: object))
            }
        })
    }
    
    func loadImage(path: String?, handlerData: @escaping HandlerObject) {
        serviceModel.loadImage(path: path, handlerData: handlerData)
    }
}
