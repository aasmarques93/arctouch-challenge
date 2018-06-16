//
//  SearchViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct SearchServiceModel: ServiceModel {
    func getGenres(requestUrl: RequestUrl, handler: @escaping Handler<MoviesGenres>) {
        let parameters: [String: Any] = [
            "language": Locale.preferredLanguages.first ?? ""
        ]
        request(requestUrl: requestUrl, urlParameters: parameters, handlerObject: { (object) in
            guard let object = object else {
                handler(MoviesGenres.handleError())
                return
            }
            handler(MoviesGenres(object: object))
        })
    }
    
    func getMoviesFromGenre(urlParameters: [String: Any], handler: @escaping Handler<SearchMoviesGenre>) {
        request(requestUrl: .searchByGenre, urlParameters: urlParameters, handlerObject: { (object) in
            guard let object = object else {
                handler(SearchMoviesGenre.handleError())
                return
            }
            handler(SearchMoviesGenre(object: object))
        })
    }
    
    func doSearch(requestUrl: RequestUrl, urlParameters: [String: Any], handler: @escaping Handler<MultiSearch>) {
        request(requestUrl: requestUrl,
                urlParameters: urlParameters,
                handlerObject: { (object) in
                    
                    guard let object = object else {
                        handler(MultiSearch.handleError())
                        return
                    }
                    
                    handler(MultiSearch(object: object))
        })
    }    
}
