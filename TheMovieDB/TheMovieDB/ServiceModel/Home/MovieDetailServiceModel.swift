//
//  MovieDetailServiceModel.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class MovieDetailServiceModel: ServiceModel {
    func getDetail(from movie: Movie, handler: @escaping HandlerObject) {
        request(MovieDetail.self,
                requestUrl: .movie,
                urlParameters: createParameters(from: movie),
                handlerObject: { (object) in
            
                    handler(object)
        })
    }
    
    func getVideos(from movie: Movie, handler: @escaping HandlerObject) {
        request(VideosList.self,
                requestUrl: .videos,
                urlParameters: createParameters(from: movie),
                handlerObject: { (object) in

                    handler(object)
        })
    }
    
    func getRecommendations(from movie: Movie, handler: @escaping HandlerObject) {
        request(MoviesList.self,
                requestUrl: .recommendations,
                urlParameters: createParameters(from: movie, isSimple: false),
                handlerObject: { (object) in
                    
                    handler(object)
        })
    }
    
    func getSimilar(from movie: Movie, handler: @escaping HandlerObject) {
        request(MoviesList.self,
                requestUrl: .similar,
                urlParameters: createParameters(from: movie, isSimple: false),
                handlerObject: { (object) in
                    
                    handler(object)
        })
    }
    
    func createParameters(from movie: Movie, isSimple: Bool = true) -> [String:Any] {
        var parameters = [String:Any]()
        parameters["idMovie"] = movie.id ?? 0
        if !isSimple { parameters["page"] = 1 }
        return parameters
    }
}
