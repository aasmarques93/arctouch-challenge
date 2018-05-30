//
//  TVShowDetailServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct TVShowDetailServiceModel {
    let serviceModel = Singleton.shared.serviceModel
    
    func getDetail(from tvShow: TVShow, handler: @escaping Handler<TVShowDetail>) {
        serviceModel.request(requestUrl: .tvDetail, urlParameters: createParameters(from: tvShow), handlerObject: { (object) in
            guard let object = object else {
                return
            }
            handler(TVShowDetail(object: object))
        })
    }
    
    func getVideos(from tvShow: TVShow, handler: @escaping Handler<VideosList>) {
        serviceModel.request(requestUrl: .tvVideos, urlParameters: createParameters(from: tvShow), handlerObject: { (object) in
            guard let object = object else {
                return
            }
            handler(VideosList(object: object))
        })
    }
    
    func getRecommendations(from tvShow: TVShow, handler: @escaping Handler<SearchTV>) {
        serviceModel.request(requestUrl: .tvRecommendations, urlParameters: createParameters(from: tvShow), handlerObject: { (object) in
            guard let object = object else {
                return
            }
            handler(SearchTV(object: object))
        })
    }
    
    func getSimilar(from tvShow: TVShow, handler: @escaping Handler<SearchTV>) {
        serviceModel.request(requestUrl: .tvSimilar, urlParameters: createParameters(from: tvShow), handlerObject: { (object) in
            guard let object = object else {
                return
            }
            handler(SearchTV(object: object))
        })
    }
    
    func getCredits(from tvShow: TVShow, handler: @escaping Handler<CreditsList>) {
        serviceModel.request(requestUrl: .tvCredits, urlParameters: createParameters(from: tvShow), handlerObject: { (object) in
            guard let object = object else {
                return
            }
            handler(CreditsList(object: object))
        })
    }
    
    func createParameters(from tvShow: TVShow) -> [String: Any] {
        let parameters: [String: Any] = [
            "id": tvShow.id ?? 0,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        return parameters
    }
    
    func rate(tvShow: TVShow, value: Float, handler: Handler<UserMovieShow>? = nil) {
        var parameters = [String: Any]()
        
        if let value = tvShow.id { parameters["showId"] = value }
        if let value = tvShow.posterPath { parameters["showImageUrl"] = value }
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
