//
//  MovieDetailServiceModel.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class MovieDetailServiceModel: ServiceModel {
    static let shared = MovieDetailServiceModel()
    
    func getMovieDetail(urlParameters: [String:Any], handler: HandlerObject? = nil) {
        request(MovieDetail.self, requestUrl: .movie, urlParameters: urlParameters, handlerObject: { (data) in
            if let handler = handler { handler(data) }
        })
    }
}
