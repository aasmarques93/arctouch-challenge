//
//  PopularPeopleServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct PopularPeopleServiceModel {
    let serviceModel = Singleton.shared.serviceModel
    
    func getPopularPeople(urlParameters: [String: Any]? = nil, handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .popularPeople, urlParameters: urlParameters, handlerObject: { (object) in
            if let object = object { handler(PopularPeople(object: object)) }
        })
    }
    
    func doSearchPerson(urlParameters: [String: Any], handler: @escaping HandlerObject) {
        serviceModel.request(requestUrl: .searchPerson, urlParameters: urlParameters, handlerObject: { (object) in
            if let object = object { handler(SearchPerson(object: object)) }
        })
    }
}
