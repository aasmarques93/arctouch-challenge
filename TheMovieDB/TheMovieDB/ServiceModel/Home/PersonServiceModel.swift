//
//  PersonServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

class PersonServiceModel: ServiceModel {
    func getPerson<T:Model>(type: T.Type, from idPerson: Int?, requestUrl: RequestUrl, handler: @escaping HandlerObject) {
        let parameters = ["idPerson": idPerson ?? 0]
        request(type, requestUrl: requestUrl, urlParameters: parameters, handlerObject: { (object) in
            handler(object)
        })
    }
}
