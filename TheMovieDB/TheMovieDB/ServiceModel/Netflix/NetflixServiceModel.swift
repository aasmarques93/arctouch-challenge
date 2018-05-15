//
//  NetflixServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import SwiftyJSON

struct NetflixServiceModel {
    let serviceModel = Singleton.shared.serviceModel
    
    func getNetflixMovies(handler: @escaping HandlerObject) {
        let urlParameters = ["contentKind": "movie"]
        serviceModel.request(requestUrl: .netflixMoviesShow,
                             environmentBase: .reelgood,
                             urlParameters: urlParameters,
                             handlerObject: { (object) in
                                
                                guard let array = object as? [JSON] else {
                                    return
                                }
                                
                                var arrayNetflix = [Netflix]()
                                array.forEach({ (data) in
                                    arrayNetflix.append(Netflix(object: data))
                                })
                                handler(arrayNetflix)
        })
    }
    
    func getNetflixDetail(movieShow: Netflix, isMovie: Bool = true, handler: @escaping HandlerObject) {
        let urlParameters: [String: Any] = [
            "id": movieShow.id ?? "",
            "contentKind": isMovie ? "movie" : "show"
        ]
        serviceModel.request(requestUrl: .netflixMovieShowDetail,
                             environmentBase: .reelgood,
                             urlParameters: urlParameters,
                             handlerObject: { (object) in
                                
                                if let object = object { handler(NetflixMovieShow(object: object)) }
        })
    }
    
    func getComingOrLeavingNetflixMovies(requestUrl: RequestUrl, handler: @escaping HandlerObject) {
        let urlParameters = ["contentKind": "movie"]
        serviceModel.request(requestUrl: requestUrl,
                             environmentBase: .reelgood,
                             urlParameters: urlParameters,
                             handlerObject: { (object) in
                                
                                guard let array = object as? [JSON] else {
                                    return
                                }
                                
                                var arrayNetflix = [Netflix]()
                                array.forEach({ (data) in
                                    arrayNetflix.append(Netflix(object: data))
                                })
                                handler(arrayNetflix)
        })
    }
    
    func imageUrl(with path: String?, isMovie: Bool = true) -> String {
        let parameters: [String: Any] = [
            "id": path ?? "",
            "contentKind": isMovie ? "movie" : "show"
        ]
        return serviceModel.requestUrl(type: .netflixImage, environmentBase: .imagesReelgood, parameters: parameters)
    }
}
