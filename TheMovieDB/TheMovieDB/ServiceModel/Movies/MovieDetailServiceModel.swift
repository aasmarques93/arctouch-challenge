//
//  MovieDetailServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct MovieDetailServiceModel {
    let serviceModel = ServiceModel()
    
    func getDetail(from movie: Movie, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .movie,
                             urlParameters: createParameters(from: movie),
                             handlerObject: { (object) in
            
                                if let object = object { handler(MovieDetail(object: object)) }
        })
    }
    
    func getVideos(from movie: Movie, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .videos,
                             urlParameters: createParameters(from: movie),
                             handlerObject: { (object) in

                                if let object = object { handler(VideosList(object: object)) }
        })
    }
    
    func getRecommendations(from movie: Movie, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .recommendations,
                             urlParameters: createParameters(from: movie, isSimple: false),
                             handlerObject: { (object) in
                    
                                if let object = object { handler(MoviesList(object: object)) }
        })
    }
    
    func getSimilar(from movie: Movie, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .similar,
                             urlParameters: createParameters(from: movie, isSimple: false),
                             handlerObject: { (object) in
                    
                                if let object = object { handler(MoviesList(object: object)) }
        })
    }
    
    func getCredits(from movie: Movie, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .credits,
                             urlParameters: createParameters(from: movie),
                             handlerObject: { (object) in
                    
                                if let object = object { handler(CreditsList(object: object)) }
        })
    }
    
    func getReviews(from movie: Movie, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .reviews,
                             urlParameters: createParameters(from: movie, isSimple: false),
                             handlerObject: { (object) in
                    
                                if let object = object { handler(ReviewsList(object: object)) }
        })
    }
    
    func createParameters(from movie: Movie, isSimple: Bool = true) -> [String: Any] {
        var parameters = [String: Any]()
        parameters["idMovie"] = movie.id ?? 0
        if !isSimple { parameters["page"] = 1 }
        parameters["language"] = Locale.preferredLanguages.first ?? ""
        return parameters
    }
    
    func loadImage(path: String?, handlerData: @escaping HandlerObject) {
        serviceModel.loadImage(path: path, handlerData: handlerData)
    }
}
