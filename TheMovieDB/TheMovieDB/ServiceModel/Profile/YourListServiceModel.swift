//
//  YourListServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/19/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import SwiftyJSON

struct YourListServiceModel {
    var serviceModel: ServiceModel {
        return Singleton.shared.serviceModel
    }
    
    func getUserMovies(requestUrl: RequestUrl, handler: Handler<[UserMovieShow]>? = nil) {
        serviceModel.request(requestUrl: requestUrl, environmentBase: .heroku, handlerObject: { (object) in
            guard let array = object as? [JSON] else {
                return
            }
            var arrayMovies = [UserMovieShow]()
            
            for movie in array {
                arrayMovies.append(UserMovieShow(object: movie))
            }
            
            handler?(arrayMovies)
        })
    }
    
    func save(movie: Movie, requestUrl: RequestUrl, handler: Handler<UserMovieShow>? = nil) {
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
                                handler?(UserMovieShow(object: object))
        })
    }
    
    func delete(movie: Movie, requestUrl: RequestUrl, handler: Handler<UserMovieShow>? = nil) {
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
                                handler?(UserMovieShow(object: object))
        })
    }
    
    func getUserShows(handler: Handler<[UserMovieShow]>? = nil) {
        serviceModel.request(requestUrl: .userShowsTrack, environmentBase: .heroku, handlerObject: { (object) in
            guard let array = object as? [JSON] else {
                return
            }
            var arrayShows = [UserMovieShow]()
            
            for show in array {
                arrayShows.append(UserMovieShow(object: show))
            }
            
            handler?(arrayShows)
        })
    }
    
    func track(show: TVShowDetail, season: Int, episode: Int, handler: Handler<UserMovieShow>? = nil) {
        var parameters = [String: Any]()
        
        if let value = show.id { parameters["showId"] = value }
        if let value = show.posterPath { parameters["showImageUrl"] = value }
        
        parameters["season"] = season
        parameters["episode"] = episode
        
        serviceModel.request(method: .post,
                             requestUrl: .trackShow,
                             environmentBase: .heroku,
                             parameters: parameters,
                             handlerObject: { (object) in
                                
                                guard let object = object else {
                                    return
                                }
                                handler?(UserMovieShow(object: object))
        })
    }
    
    func imageUrl(with path: String?) -> String {
        return serviceModel.imageUrl(with: path)
    }
}
