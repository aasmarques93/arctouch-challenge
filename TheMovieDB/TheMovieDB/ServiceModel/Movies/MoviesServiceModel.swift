//
//  MoviesServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct MoviesServiceModel: ServiceModel {
    func getMovies(urlParameters: [String: Any]? = nil, requestUrl: RequestUrl, handler: @escaping Handler<MoviesList>) {
        request(requestUrl: requestUrl, urlParameters: urlParameters, handlerObject: { (object) in
            guard let object = object else {
                handler(MoviesList.handleError())
                return
            }
            handler(MoviesList(object: object))
        })
    }
    
    func getLatest(handler: @escaping Handler<Movie>) {
        let urlParameters: [String: Any] = [
            "language": Locale.preferredLanguages.first ?? ""
        ]
        request(requestUrl: .latest, urlParameters: urlParameters, handlerObject: { (object) in
            guard let object = object else {
                handler(Movie.handleError())
                return
            }
            handler(Movie(object: object))
        })
    }
}
