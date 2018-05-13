//
//  MoviesServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct MoviesServiceModel {
    let serviceModel = ServiceModel()
    
    func getMovies(urlParameters: [String: Any]? = nil, requestUrl: RequestUrl, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: requestUrl, urlParameters: urlParameters, handlerObject: { (object) in
            if let object = object { handler(MoviesList(object: object)) }
        })
    }
    
    func imageUrl(with path: String?) -> String {
        return serviceModel.imageUrl(with: path)
    }
}
