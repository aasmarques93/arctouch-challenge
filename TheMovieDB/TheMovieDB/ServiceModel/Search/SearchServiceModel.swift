//
//  SearchViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct SearchServiceModel {
    let serviceModel = Singleton.shared.serviceModel
    
    func getGenres(requestUrl: RequestUrl, handler: @escaping Handler<MoviesGenres>) {
        let parameters: [String: Any] = [
            "language": Locale.preferredLanguages.first ?? ""
        ]
        serviceModel.request(requestUrl: requestUrl, urlParameters: parameters, handlerObject: { (object) in
            guard let object = object else {
                return
            }
            handler(MoviesGenres(object: object))
        })
    }
    
    func getMoviesFromGenre(urlParameters: [String: Any], handler: @escaping Handler<SearchMoviesGenre>) {
        serviceModel.request(requestUrl: .searchByGenre, urlParameters: urlParameters, handlerObject: { (object) in
            guard let object = object else {
                return
            }
            handler(SearchMoviesGenre(object: object))
        })
    }
    
    func doSearch(requestUrl: RequestUrl, urlParameters: [String: Any], handler: @escaping Handler<MultiSearch>) {
        serviceModel.request(requestUrl: requestUrl,
                             urlParameters: urlParameters,
                             handlerObject: { (object) in
            
                                guard let object = object else {
                                    return
                                }
                                handler(MultiSearch(object: object))
        })
    }
    
    func imageUrl(with path: String?) -> String {
        return serviceModel.imageUrl(with: path)
    }
}
