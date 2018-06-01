//
//  EpisodesServiceModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/5/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

struct EpisodesServiceModel: ServiceModel {
    func getImages(from id: Int?, season: Int?, episode: Int?, handler: @escaping Handler<EpisodeImagesList>) {
        if let id = id, let seasonNumber = season, let episodeNumber = episode {
            let parameters: [String: Any] = [
                "id": id,
                "season": seasonNumber,
                "episode": episodeNumber,
                "language": Locale.preferredLanguages.first ?? ""
            ]
            request(requestUrl: .tvImages, urlParameters: parameters, handlerObject: { (object) in
                guard let object = object else {
                    return
                }
                handler(EpisodeImagesList(object: object))
            })
        }
    }
}
