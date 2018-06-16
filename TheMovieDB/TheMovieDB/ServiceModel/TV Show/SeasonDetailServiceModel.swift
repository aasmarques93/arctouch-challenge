//
//  SeasonDetailServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/30/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct SeasonDetailServiceModel: ServiceModel {
    func getDetail(from tvShowDetail: TVShowDetail?, season: Seasons?, handler: @escaping Handler<SeasonDetail>) {
        if let id = tvShowDetail?.id, let seasonNumber = season?.seasonNumber {
            let parameters: [String: Any] = [
                "id": id,
                "season": seasonNumber,
                "language": Locale.preferredLanguages.first ?? ""
            ]
            request(requestUrl: RequestUrl.seasonDetail, urlParameters: parameters, handlerObject: { (object) in
                guard let object = object else {
                    handler(SeasonDetail.handleError())
                    return
                }
                handler(SeasonDetail(object: object))
            })
        }
    }
}
