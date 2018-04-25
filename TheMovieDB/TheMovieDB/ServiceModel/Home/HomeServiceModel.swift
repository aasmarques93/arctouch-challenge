//
//  HomeServiceModel.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class HomeServiceModel: ServiceModel {
    static let shared = HomeServiceModel()
    
    func getMovies(urlParameters: [String:Any]? = nil, requestUrl: RequestUrl, handler: @escaping HandlerObject) {
        request(MoviesList.self, requestUrl: requestUrl, urlParameters: urlParameters, handlerObject: { (object) in
            handler(object)
        })
    }
}
