//
//  NetflixServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import SwiftyJSON

struct NetflixServiceModel: ServiceModel {
    func getNetflixGenres(handler: @escaping Handler<[Genres]>) {
        let requestUrl: RequestUrl = Singleton.shared.isLanguagePortuguese ? .netflixGenresBR : .netflixGenres
        request(requestUrl: requestUrl, environmentBase: .heroku, handlerObject: { (object) in
            guard let object = object else {
                return
            }
            
            let netflixGenres = NetflixGenres(object: object)
            guard let genres = netflixGenres.genres else {
                return
            }
            handler(genres)
        })
    }
    
    func getNetflixMoviesShow(genre: Int? = nil, isMovie: Bool = true, handler: @escaping Handler<[Netflix]>) {
        var urlParameters: [String: Any] = [
            "contentKind": isMovie ? "movie" : "show"
        ]
        
        if let genre = genre {
            urlParameters["genre"] = genre
        }
        
        request(requestUrl: .netflixMoviesShow,
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
    
    func getNetflixDetail(movieShow: Netflix, isMovie: Bool = true, handler: @escaping Handler<NetflixMovieShow>) {
        let urlParameters: [String: Any] = [
            "id": movieShow.id ?? "",
            "contentKind": isMovie ? "movie" : "show"
        ]
        request(requestUrl: .netflixMovieShowDetail,
                environmentBase: .reelgood,
                urlParameters: urlParameters,
                handlerObject: { (object) in
                    
                    guard let object = object else {
                        return
                    }
                    handler(NetflixMovieShow(object: object))
        })
    }
    
    func getComingOrLeavingNetflixMovies(requestUrl: RequestUrl, handler: @escaping Handler<[Netflix]>) {
        let urlParameters = ["contentKind": "movie"]
        request(requestUrl: requestUrl,
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
    
    func doSpin(genre: Genres?,
                isMovieOn: Bool,
                isTVShowOn: Bool,
                imdb: Int? = nil,
                rottenTomatoes: Int? = nil,
                handler: @escaping Handler<[Netflix]>) {
        
        var urlParameters = [String: Any]()
        
        var genreParameter = "", imdbParameter = "", rottenTomatoesParameter = ""
        
        if let value = genre?.id { genreParameter = "\(value)" }
        if let value = imdb { imdbParameter = "\(value)" }
        if let value = rottenTomatoes { rottenTomatoesParameter = "\(value)" }
        
        urlParameters["genre"] = genreParameter
        urlParameters["imdb"] = imdbParameter
        urlParameters["rottenTomatoes"] = rottenTomatoesParameter
        urlParameters["contentKind"] = isMovieOn && isTVShowOn ? "both" : isMovieOn ? "movie" : "show"
        
        request(requestUrl: .roulette,
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
        return requestUrl(type: .netflixImage, environmentBase: .imagesReelgood, parameters: parameters)
    }
}
