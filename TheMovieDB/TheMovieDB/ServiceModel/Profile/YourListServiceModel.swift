//
//  YourListServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/19/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import SwiftyJSON

struct YourListServiceModel {
    let serviceModel = ServiceModel()
    
    func getUserMovies(requestUrl: RequestUrl, handler: HandlerObject? = nil) {
        serviceModel.request(requestUrl: requestUrl, environmentBase: .heroku, handlerObject: { (object) in
            guard let array = object as? [JSON] else {
                return
            }
            var arrayMovies = [UserMovie]()
            
            for movie in array {
                arrayMovies.append(UserMovie(object: movie))
            }
            
            handler?(arrayMovies)
        })
    }
    
    func save(movie: Movie, requestUrl: RequestUrl, handler: HandlerObject? = nil) {
        var parameters = [String: Any]()
        
        if let value = movie.id { parameters["movieId"] = value }
        if let value = movie.posterPath { parameters["movieImageUrl"] = value }
        
        serviceModel.request(method: .post,
                             requestUrl: requestUrl,
                             environmentBase: .heroku,
                             parameters: parameters,
                             handlerObject: { (object) in
            
                                guard let object = object else {
                                    return
                                }
                                handler?(UserMovie(object: object))
        })
    }
    
    func delete(movie: Movie, requestUrl: RequestUrl, handler: HandlerObject? = nil) {
        var parameters = [String: Any]()
        
        if let value = movie.id { parameters["movieId"] = value }
        
        serviceModel.request(method: .post,
                             requestUrl: requestUrl,
                             environmentBase: .heroku,
                             parameters: parameters,
                             handlerObject: { (object) in
                                
                                guard let object = object else {
                                    return
                                }
                                handler?(UserMovie(object: object))
        })
    }
    
    func imageUrl(with path: String?) -> String {
        return serviceModel.imageUrl(with: path)
    }
}
