//
//  TVShowServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct TVShowServiceModel {
    let serviceModel = ServiceModel()
    
    func getPopular(urlParameters: [String:Any]? = nil, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .tvPopular, urlParameters: urlParameters, handlerObject: { (object) in
            if let object = object { handler(SearchTV(object: object)) }
        })
    }
    
    func doSearchTVShow(urlParameters: [String:Any], handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .searchTV, urlParameters: urlParameters, handlerObject: { (object) in
            if let object = object { handler(SearchTV(object: object)) }
        })
    }
}
