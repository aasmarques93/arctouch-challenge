//
//  TVShowServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct TVShowServiceModel {
    let serviceModel = Singleton.shared.serviceModel
    
    func getTVShow(requestUrl: RequestUrl, urlParameters: [String: Any]? = nil, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: requestUrl, urlParameters: urlParameters, handlerObject: { (object) in
            if let object = object { handler(SearchTV(object: object)) }
        })
    }
    
    func doSearchTVShow(urlParameters: [String: Any], handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .searchTV, urlParameters: urlParameters, handlerObject: { (object) in
            if let object = object { handler(SearchTV(object: object)) }
        })
    }
    
    func getLatest(handler: @escaping HandlerObject) {
        let urlParameters: [String: Any] = [
            "language": Locale.preferredLanguages.first ?? ""
        ]
        serviceModel.request(requestUrl: .tvLatest, urlParameters: urlParameters, handlerObject: { (object) in
            if let object = object { handler(TVShow(object: object)) }
        })
    }
    
    func imageUrl(with path: String?) -> String {
        return serviceModel.imageUrl(with: path)
    }
    
    func loadImage(path: String?, handlerData: @escaping HandlerObject) {
        serviceModel.loadImage(path: path, handlerData: handlerData)
    }
}
