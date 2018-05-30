//
//  TVShowServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct TVShowServiceModel {
    let serviceModel = Singleton.shared.serviceModel
    
    func getTVShow(requestUrl: RequestUrl, urlParameters: [String: Any]? = nil, handler: @escaping Handler<SearchTV>) {
        serviceModel.request(requestUrl: requestUrl, urlParameters: urlParameters, handlerObject: { (object) in
            guard let object = object else {
                return
            }
            handler(SearchTV(object: object))
        })
    }
    
    func doSearchTVShow(urlParameters: [String: Any], handler: @escaping Handler<SearchTV>) {
        serviceModel.request(requestUrl: .searchTV, urlParameters: urlParameters, handlerObject: { (object) in
            guard let object = object else {
                return
            }
            handler(SearchTV(object: object))
        })
    }
    
    func getLatest(handler: @escaping Handler<TVShow>) {
        let urlParameters: [String: Any] = [
            "language": Locale.preferredLanguages.first ?? ""
        ]
        serviceModel.request(requestUrl: .tvLatest, urlParameters: urlParameters, handlerObject: { (object) in
            guard let object = object else {
                return
            }
            handler(TVShow(object: object))
        })
    }
    
    func imageUrl(with path: String?) -> String {
        return serviceModel.imageUrl(with: path)
    }    
}
