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
    
    func getGenres(handler: HandlerObject? = nil) {
        request(MoviesGenres.self, requestUrl: .genres, handlerObject: { (data) in
            if let handler = handler { handler(data) }
        })
    }
    
    func getMoviesFromGenre(urlParameters: [String:Any], handler: HandlerObject? = nil) {
        request(SearchMoviesGenre.self, requestUrl: .searchByGenre, urlParameters: urlParameters, handlerObject: { (data) in
            if let handler = handler { handler(data) }
        })
    }
    
    func doSearchMovies(urlParameters: [String:Any], handler: HandlerObject? = nil) {
        request(SearchMovie.self, requestUrl: .searchMovie, urlParameters: urlParameters, handlerObject: { (data) in
            if let handler = handler { handler(data) }
        })
    }
}
