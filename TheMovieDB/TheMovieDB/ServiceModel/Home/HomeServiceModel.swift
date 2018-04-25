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
    
    func getUpcomingMovies(urlParameters: [String:Any]? = nil, handler: HandlerObject? = nil) {
        request(UpcomingMoviesList.self, requestUrl: .upcoming, urlParameters: urlParameters, handlerObject: { (data) in
            if let handler = handler { handler(data) }
        })
    }
    
    func getTopRated(urlParameters: [String:Any]? = nil, handler: HandlerObject? = nil) {
        request(TopRatedList.self, requestUrl: .topRated, urlParameters: urlParameters, handlerObject: { (data) in
            if let handler = handler { handler(data) }
        })
    }
    
    func getPopularList(urlParameters: [String:Any]? = nil, handler: HandlerObject? = nil) {
        request(PopularList.self, requestUrl: .popular, urlParameters: urlParameters, handlerObject: { (data) in
            if let handler = handler { handler(data) }
        })
    }
}
