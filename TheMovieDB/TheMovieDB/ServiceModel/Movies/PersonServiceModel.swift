//
//  PersonServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct PersonServiceModel: ServiceModel {
    func getPerson(from idPerson: Int?, requestUrl: RequestUrl, handler: @escaping HandlerObject) {
        let parameters: [String: Any] = [
            "idPerson": idPerson ?? 0,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        request(requestUrl: requestUrl, urlParameters: parameters, handlerObject: { (object) in
            guard let object = object else {
                return
            }
            
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
        })
    }
    
    func getImages(from idPerson: Int?, handler: @escaping Handler<PersonImagesList>) {
        let parameters: [String: Any] = [
            "idPerson": idPerson ?? 0,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        request(requestUrl: .personImages, urlParameters: parameters, handlerObject: { (object) in
            guard let object = object else {
                return
            }
            
            handler(PersonImagesList(object: object))
        })
    }
}
