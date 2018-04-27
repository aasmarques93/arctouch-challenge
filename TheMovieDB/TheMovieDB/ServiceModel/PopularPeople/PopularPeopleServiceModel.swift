//
//  PopularPeopleServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

class PopularPeopleServiceModel: ServiceModel {
    func getPopularPeople(urlParameters: [String:Any]? = nil, handler: @escaping HandlerObject) {
        request(PopularPeople.self, requestUrl: .popularPeople, urlParameters: urlParameters, handlerObject: { (object) in
            handler(object)
        })
    }
    
    func doSearchPerson(urlParameters: [String:Any], handler: @escaping HandlerObject) {
        request(SearchPerson.self, requestUrl: .searchPerson, urlParameters: urlParameters, handlerObject: { (object) in
            handler(object)
        })
    }
}
