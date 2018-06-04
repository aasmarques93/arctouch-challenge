//
//  MovieDetailServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct MovieDetailServiceModel: ServiceModel {
    func getDetail(from movie: Movie, handler: @escaping Handler<MovieDetail>) {
        request(requestUrl: .movie,
                urlParameters: createParameters(from: movie),
                handlerObject: { (object) in
                    
                    guard let object = object else {
                        handler(MovieDetail.handleError())
                        return
                    }
                    
                    handler(MovieDetail(object: object))
        })
    }
    
    func getVideos(from movie: Movie, handler: @escaping Handler<VideosList>) {
        request(requestUrl: .videos,
                urlParameters: createParameters(from: movie),
                handlerObject: { (object) in
                    
                    guard let object = object else {
                        handler(VideosList.handleError())
                        return
                    }
                    
                    handler(VideosList(object: object))
        })
    }
    
    func getRecommendations(from movie: Movie, handler: @escaping Handler<MoviesList>) {
        request(requestUrl: .recommendations,
                urlParameters: createParameters(from: movie, isSimple: false),
                handlerObject: { (object) in
                    
                    guard let object = object else {
                        handler(MoviesList.handleError())
                        return
                    }
                    
                    handler(MoviesList(object: object))
        })
    }
    
    func getSimilar(from movie: Movie, handler: @escaping Handler<MoviesList>) {
        request(requestUrl: .similar,
                urlParameters: createParameters(from: movie, isSimple: false),
                handlerObject: { (object) in
                    
                    guard let object = object else {
                        handler(MoviesList.handleError())
                        return
                    }
                    
                    handler(MoviesList(object: object))
        })
    }
    
    func getCredits(from movie: Movie, handler: @escaping Handler<CreditsList>) {
        request(requestUrl: .credits,
                urlParameters: createParameters(from: movie),
                handlerObject: { (object) in
                    
                    guard let object = object else {
                        handler(CreditsList.handleError())
                        return
                    }
                    
                    handler(CreditsList(object: object))
        })
    }
    
    func getReviews(from movie: Movie, handler: @escaping Handler<ReviewsList>) {
        request(requestUrl: .reviews,
                urlParameters: createParameters(from: movie, isSimple: false),
                handlerObject: { (object) in
                    
                    guard let object = object else {
                        handler(ReviewsList.handleError())
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
    
    func rate(movie: Movie, value: Float, handler: Handler<UserMovieShow>? = nil) {
        var parameters = [String: Any]()
        
        if let value = movie.id { parameters["movieId"] = value }
        if let value = movie.posterPath { parameters["movieImageUrl"] = value }
        parameters["rate"] = value
        
        request(method: .post,
                requestUrl: .rate,
                environmentBase: .heroku,
                parameters: parameters,
                handlerObject: { (object) in
                    
                    guard let object = object else {
                        handler?(UserMovieShow.handleError())
                        return
                    }
                    
                    handler?(UserMovieShow(object: object))
        })
    }    
}
