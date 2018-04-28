//
//  SearchViewModel.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

class SearchServiceModel: ServiceModel {
    func getGenres(requestUrl: RequestUrl, handler: @escaping HandlerObject) {
        request(MoviesGenres.self, requestUrl: requestUrl, handlerObject: { (object) in
            handler(object)
        })
    }
    
    func getMoviesFromGenre(urlParameters: [String:Any], handler: @escaping HandlerObject) {
        request(SearchMoviesGenre.self, requestUrl: .searchByGenre, urlParameters: urlParameters, handlerObject: { (object) in
            handler(object)
        })
    }
    
    func doSearchMovies(urlParameters: [String:Any], handler: @escaping HandlerObject) {
        request(SearchMovie.self, requestUrl: .searchMovie, urlParameters: urlParameters, handlerObject: { (object) in
            handler(object)
        })
    }
}
