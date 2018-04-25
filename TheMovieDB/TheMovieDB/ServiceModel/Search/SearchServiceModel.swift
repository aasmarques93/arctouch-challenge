//
//  SearchViewModel.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class SearchServiceModel: ServiceModel {
    static let shared = SearchServiceModel()
    
    func getGenres(handler: @escaping HandlerObject) {
        request(MoviesGenres.self, requestUrl: .genres, handlerObject: { (object) in
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
