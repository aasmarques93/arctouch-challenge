//
//  TVShowServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct TVShowServiceModel: ServiceModel {
    func getTVShow(requestUrl: RequestUrl, urlParameters: [String: Any]? = nil, handler: @escaping Handler<SearchTV>) {
        request(requestUrl: requestUrl, urlParameters: urlParameters, handlerObject: { (object) in
            guard let object = object else {
                handler(SearchTV.handleError())
                return
            }
            handler(SearchTV(object: object))
        })
    }
    
    func doSearchTVShow(urlParameters: [String: Any], handler: @escaping Handler<SearchTV>) {
        request(requestUrl: .searchTV, urlParameters: urlParameters, handlerObject: { (object) in
            guard let object = object else {
                handler(SearchTV.handleError())
                return
            }
            handler(SearchTV(object: object))
        })
    }
    
    func getLatest(handler: @escaping Handler<TVShow>) {
        let urlParameters: [String: Any] = [
            "language": Locale.preferredLanguages.first ?? ""
        ]
        request(requestUrl: .tvLatest, urlParameters: urlParameters, handlerObject: { (object) in
            guard let object = object else {
                handler(TVShow.handleError())
                return
            }
            handler(TVShow(object: object))
        })
    }
}
