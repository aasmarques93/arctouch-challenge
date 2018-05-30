//
//  TrackEpisodeCellViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/21/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class TrackEpisodeCellViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: ViewModelDelegate?
    
    // MARK: Observables
    var contentAlpha = Observable<CGFloat>(1)
    var photo = Observable<UIImage?>(#imageLiteral(resourceName: "default-image"))
    var title = Observable<String?>(nil)
    
    // MARK: Objects
    private var episode: Episodes
    var isSelected: Bool
    
    // MARK: Variables
    var imagePathUrl: URL? {
        return URL(string: Singleton.shared.serviceModel.imageUrl(with: episode.stillPath))
    }
    
    // MARK: - Life cycle -
    
    init(episode: Episodes, isSelected: Bool) {
        self.episode = episode
        self.isSelected = isSelected
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        contentAlpha.value = isSelected ? 1.0 : 0.5
        
        guard let episodeNumber = episode.episodeNumber else {
            return
        }
        title.value = "\(Titles.episode.localized) \(episodeNumber)"
    }
}
