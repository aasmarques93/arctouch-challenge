//
//  SearchViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct SearchServiceModel {
    let serviceModel = ServiceModel()
    
    func getGenres(requestUrl: RequestUrl, handler: @escaping HandlerObject) {
        let parameters: [String: Any] = [
            "language": Locale.preferredLanguages.first ?? ""
        ]
        serviceModel.request(requestUrl: requestUrl, urlParameters: parameters, handlerObject: { (object) in
            if let object = object { handler(MoviesGenres(object: object)) }
        })
    }
    
    func getMoviesFromGenre(urlParameters: [String:Any], handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .searchByGenre, urlParameters: urlParameters, handlerObject: { (object) in
            if let object = object { handler(SearchMoviesGenre(object: object)) }
        })
    }
    
    func doSearch(urlParameters: [String:Any], isMultipleSearch: Bool, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: isMultipleSearch ? .multiSearch: .searchMovie,
                             urlParameters: urlParameters,
                             handlerObject: { (object) in
            
                                if let object = object { handler(MultiSearch(object: object)) }
        })
    }
    
    func imageUrl(with path: String?) -> String {
        return serviceModel.imageUrl(with: path)
    }
}
