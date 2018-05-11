//
//  EpisodesServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/5/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

struct EpisodesServiceModel {
    let serviceModel = ServiceModel()

    func getImages(from id: Int?, season: Int?, episode: Int?, handler: @escaping HandlerObject) {
        if let id = id, let seasonNumber = season, let episodeNumber = episode {
            let parameters: [String: Any] = [
                "id": id,
                "season": seasonNumber,
                "episode": episodeNumber,
                "language": Locale.preferredLanguages.first ?? ""
            ]
            serviceModel.request(requestUrl: .tvImages, urlParameters: parameters, handlerObject: { (object) in
                if let object = object { handler(EpisodeImagesList(object: object)) }
            })
        }
    }

    func loadImage(path: String?, handlerData: @escaping HandlerObject) {
        serviceModel.loadImage(path: path, handlerData: handlerData)
    }
}
