//
//  TVShowServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

class TVShowServiceModel: ServiceModel {
    func getPopular(urlParameters: [String:Any]? = nil, handler: @escaping HandlerObject) {
        request(SearchTV.self, requestUrl: .tvPopular, urlParameters: urlParameters, handlerObject: { (object) in
            handler(object)
        })
    }
    
    func doSearchTVShow(urlParameters: [String:Any], handler: @escaping HandlerObject) {
        request(SearchTV.self, requestUrl: .searchTV, urlParameters: urlParameters, handlerObject: { (object) in
            handler(object)
        })
    }
}
