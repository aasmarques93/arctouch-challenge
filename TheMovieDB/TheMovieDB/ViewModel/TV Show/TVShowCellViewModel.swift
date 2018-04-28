//
//  TVShowCellViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class TVShowCellViewModel: ViewModel {
    var photo = Observable<UIImage?>(#imageLiteral(resourceName: "searching"))
    var title = Observable<String?>(nil)
    var date = Observable<String?>(nil)
    var overview = Observable<String?>(nil)
    
    var movie: Movie?
    
    init(_ object: Movie) {
        super.init()
        self.movie = object
    }
    
    func setupData() {
        title.value = valueDescription(movie?.title)
        date.value = valueDescription(movie?.firstAirDate)
        overview.value = valueDescription(movie?.overview)
        
        loadImageData()
    }
    
    private func loadImageData() {
        ServiceModel().loadImage(path: movie?.posterPath ?? "", handlerData: { (data) in
            if let data = data as? Data { self.photo.value = UIImage(data: data) }
        })
    }
}
