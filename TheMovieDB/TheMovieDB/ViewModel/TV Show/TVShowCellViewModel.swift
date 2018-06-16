//
//  TVShowCellViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class TVShowCellViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Observables
    var title = Observable<String?>(nil)
    var date = Observable<String?>(nil)
    var overview = Observable<String?>(nil)
    
    // MARK: Observables
    private var tvShow: TVShow?
    
    // MARK: Variables
    var imageUrl: URL? {
        return URL(string: Singleton.shared.serviceModel.imageUrl(with: tvShow?.posterPath ?? ""))
    }

    // MARK: - Life cycle -
    
    init(_ object: TVShow) {
        self.tvShow = object
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        title.value = valueDescription(tvShow?.name)
        date.value = "Since: \(valueDescription(tvShow?.firstAirDate))"
        overview.value = valueDescription(tvShow?.overview)
    }
    
}
