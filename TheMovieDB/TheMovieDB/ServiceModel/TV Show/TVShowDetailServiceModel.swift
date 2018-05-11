//
//  TVShowDetailServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct TVShowDetailServiceModel {
    let serviceModel = ServiceModel()
    
    func getDetail(from id: Int?, handler: @escaping HandlerObject) {
        let parameters: [String: Any] = [
            "id": id ?? 0,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        serviceModel.request(requestUrl: .tvDetail, urlParameters: parameters, handlerObject: { (object) in
            if let object = object { handler(TVShowDetail(object: object)) }
        })
    }
    
    func getVideos(from id: Int?, handler: @escaping HandlerObject) {
        let parameters: [String: Any] = [
            "id": id ?? 0,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        serviceModel.request(requestUrl: .tvVideos, urlParameters: parameters, handlerObject: { (object) in
            if let object = object { handler(VideosList(object: object)) }
        })
    }
    
    func getCredits(from id: Int?, handler: @escaping HandlerObject) {
        let parameters: [String: Any] = [
            "id": id ?? 0,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        serviceModel.request(requestUrl: .tvCredits, urlParameters: parameters, handlerObject: { (object) in
            if let object = object { handler(CreditsList(object: object)) }
        })
    }
}
