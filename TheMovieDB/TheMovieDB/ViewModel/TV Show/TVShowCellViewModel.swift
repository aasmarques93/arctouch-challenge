//
//  TVShowCellViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class TVShowCellViewModel: ViewModel {
    var photo = Observable<UIImage?>(#imageLiteral(resourceName: "default-image"))
    var title = Observable<String?>(nil)
    var date = Observable<String?>(nil)
    var overview = Observable<String?>(nil)
    
    var tvShow: TVShow?
    
    init(_ object: TVShow) {
        self.tvShow = object
    }
    
    func loadData() {
        title.value = valueDescription(tvShow?.name)
        date.value = "Since: \(valueDescription(tvShow?.firstAirDate))"
        overview.value = valueDescription(tvShow?.overview)
        
        loadImageData()
    }
    
    private func loadImageData() {
        ServiceModel().loadImage(path: tvShow?.posterPath ?? "", handlerData: { (data) in
            if let data = data as? Data { self.photo.value = UIImage(data: data) }
        })
    }
}
