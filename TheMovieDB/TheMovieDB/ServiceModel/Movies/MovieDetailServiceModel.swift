//
//  MovieDetailServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct MovieDetailServiceModel {
    let serviceModel = Singleton.shared.serviceModel
    
    func getDetail(from movie: Movie, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .movie,
                             urlParameters: createParameters(from: movie),
                             handlerObject: { (object) in
            
                                guard let object = object else {
                                    return
                                }
                                handler(MovieDetail(object: object))
        })
    }
    
    func getVideos(from movie: Movie, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .videos,
                             urlParameters: createParameters(from: movie),
                             handlerObject: { (object) in

                                guard let object = object else {
                                    return
                                }
                                handler(VideosList(object: object))
        })
    }
    
    func getRecommendations(from movie: Movie, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .recommendations,
                             urlParameters: createParameters(from: movie, isSimple: false),
                             handlerObject: { (object) in
                    
                                guard let object = object else {
                                    return
                                }
                                handler(MoviesList(object: object))
        })
    }
    
    func getSimilar(from movie: Movie, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .similar,
                             urlParameters: createParameters(from: movie, isSimple: false),
                             handlerObject: { (object) in
                    
                                guard let object = object else {
                                    return
                                }
                                handler(MoviesList(object: object))
        })
    }
    
    func getCredits(from movie: Movie, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .credits,
                             urlParameters: createParameters(from: movie),
                             handlerObject: { (object) in
                    
                                guard let object = object else {
                                    return
                                }
                                handler(CreditsList(object: object))
        })
    }
    
    func getReviews(from movie: Movie, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .reviews,
                             urlParameters: createParameters(from: movie, isSimple: false),
                             handlerObject: { (object) in
                    
                                guard let object = object else {
                                    return
                                }                      
                                handler(ReviewsList(object: object))
        })
    }
    
    func createParameters(from movie: Movie, isSimple: Bool = true) -> [String: Any] {
        var parameters = [String: Any]()
        parameters["idMovie"] = movie.id ?? 0
        if !isSimple { parameters["page"] = 1 }
        parameters["language"] = Locale.preferredLanguages.first ?? ""
        return parameters
    }
    
    func rate(movie: Movie, value: Float, handler: HandlerObject? = nil) {
        var parameters = [String: Any]()
        
        if let value = movie.id { parameters["movieId"] = value }
        if let value = movie.posterPath { parameters["movieImageUrl"] = value }
        parameters["rate"] = value
        
        serviceModel.request(method: .post,
                             requestUrl: .rate,
                             environmentBase: .heroku,
                             parameters: parameters,
                             handlerObject: { (object) in
                                
                                guard let object = object else {
                                    return
                                }
                                handler?(UserMovieShow(object: object))
        })
    }    
}
