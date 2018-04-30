//
//  SeasonDetailViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/30/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class EpisodeViewModel: ViewModel {
    var photo = Observable<UIImage?>(#imageLiteral(resourceName: "default-image"))
    var title = Observable<String?>(nil)
    var date = Observable<String?>(nil)
    var overview = Observable<String?>(nil)
    
    var episode: Episodes?
    
    init(_ object: Episodes) {
        super.init()
        self.episode = object
    }
    
    func setupData() {
        title.value = "Episode \(valueDescription(episode?.episodeNumber)) - \(valueDescription(episode?.name))"
        date.value = "Air Date: \(valueDescription(episode?.airDate))"
        overview.value = valueDescription(episode?.overview)
        
        loadImageData()
    }
    
    private func loadImageData() {
        ServiceModel().loadImage(path: episode?.stillPath ?? "", handlerData: { (data) in
            if let data = data as? Data { self.photo.value = UIImage(data: data) }
        })
    }
}
