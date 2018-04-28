//
//  TVShowDetailServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

class TVShowDetailServiceModel: ServiceModel {
    func getDetail(from id: Int?, handler: @escaping HandlerObject) {
        let parameters = ["id": id ?? 0]
        request(TVShowDetail.self, requestUrl: .tvDetail, urlParameters: parameters, handlerObject: { (object) in
                handler(object)
        })
    }
    
    func getVideos(from id: Int?, handler: @escaping HandlerObject) {
        let parameters = ["id": id ?? 0]
        request(VideosList.self, requestUrl: .tvVideos, urlParameters: parameters, handlerObject: { (object) in
            handler(object)
        })
    }
    
    func getCredits(from id: Int?, handler: @escaping HandlerObject) {
        let parameters = ["id": id ?? 0]
        request(CreditsList.self, requestUrl: .tvCredits, urlParameters: parameters, handlerObject: { (object) in
            handler(object)
        })
    }
}
