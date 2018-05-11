//
//  SeasonDetailServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/30/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

struct SeasonDetailServiceModel {
    let serviceModel = ServiceModel()
    
    func getDetail(from tvShowDetail: TVShowDetail?, season: Seasons?, handler: @escaping HandlerObject) {
        if let id = tvShowDetail?.id, let seasonNumber = season?.seasonNumber {
            let parameters: [String: Any] = [
                "id": id,
                "season": seasonNumber,
                "language": Locale.preferredLanguages.first ?? ""
            ]
            serviceModel.request(requestUrl: .seasonDetail, urlParameters: parameters, handlerObject: { (object) in
                if let object = object { handler(SeasonDetail(object: object)) }
            })
        }
    }

    func loadImage(path: String?, handlerData: @escaping HandlerObject) {
        serviceModel.loadImage(path: path, handlerData: handlerData)
    }
}
