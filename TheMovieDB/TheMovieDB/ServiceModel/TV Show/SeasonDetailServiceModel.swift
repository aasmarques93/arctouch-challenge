//
//  SeasonDetailServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/30/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct SeasonDetailServiceModel {
    let serviceModel = Singleton.shared.serviceModel
    
    func getDetail(from tvShowDetail: TVShowDetail?, season: Seasons?, handler: @escaping Handler<SeasonDetail>) {
        if let id = tvShowDetail?.id, let seasonNumber = season?.seasonNumber {
            let parameters: [String: Any] = [
                "id": id,
                "season": seasonNumber,
                "language": Locale.preferredLanguages.first ?? ""
            ]
            serviceModel.request(requestUrl: RequestUrl.seasonDetail, urlParameters: parameters, handlerObject: { (object) in
                guard let object = object else {
                    return
                }
                handler(SeasonDetail(object: object))
            })
        }
    }
}
