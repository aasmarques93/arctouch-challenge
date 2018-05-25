//
//  MoviesServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct MoviesServiceModel {
    let serviceModel = Singleton.shared.serviceModel
    
    func getMovies(urlParameters: [String: Any]? = nil, requestUrl: RequestUrl, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: requestUrl, urlParameters: urlParameters, handlerObject: { (object) in
            if let object = object { handler(MoviesList(object: object)) }
        })
    }
    
    func getLatest(handler: @escaping HandlerObject) {
        let urlParameters: [String: Any] = [
            "language": Locale.preferredLanguages.first ?? ""
        ]
        serviceModel.request(requestUrl: .latest, urlParameters: urlParameters, handlerObject: { (object) in
            if let object = object { handler(Movie(object: object)) }
        })
    }
    
    func imageUrl(with path: String?) -> String {
        return serviceModel.imageUrl(with: path)
    }    
}
