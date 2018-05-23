//
//  TrackViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/21/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

protocol TrackViewModelDelegate: ViewModelDelegate {
    func reloadData(at index: Int)
}

class TrackViewModel: ViewModel {
    // MARK: Delegate
    weak var delegate: TrackViewModelDelegate?
    
    // MARK: Service Model
    let serviceModel = SeasonDetailServiceModel()
    let yourListServiceModel = YourListServiceModel()
    
    // MARK: Objects
    private var tvShowDetail: TVShowDetail
    private var userShowTracked: UserMovieShow?
    
    private var seasonDetailCount = 0
    
    private var arraySeasons: [Seasons]
    private var arraySeasonsDetail = [SeasonDetail]() { didSet { delegate?.reloadData?() } }
    var numberOfSeasons: Int { return arraySeasonsDetail.count }
    
    private var dictionarySelectedEpisodes = [Int: [Episodes]]()
    private var dictionaryLastIndexPathsDisplayed = [Int: IndexPath]()
    
    init(tvShowDetail: TVShowDetail, arraySeasons: [Seasons]) {
        self.tvShowDetail = tvShowDetail
        self.arraySeasons = arraySeasons
        
        Singleton.shared.loadUserData()
    }
    
    func loadData() {
        arraySeasons.forEach { [weak self] (season) in
            self?.loadDetailFrom(season: season)
        }
    }
    
    func loadDetailFrom(season: Seasons) {
        serviceModel.getDetail(from: tvShowDetail, season: season) { [weak self] (object) in
            guard let seasonDetail = object as? SeasonDetail else {
                return
            }
            
            self?.addSeasonDetailToArray(seasonDetail)
            self?.seasonDetailCount += 1
            
            guard let count = self?.seasonDetailCount, let max = self?.arraySeasons.count, count == max else {
                return
            }
            
            self?.trackUserShows()
        }
    }

    private func addSeasonDetailToArray(_ seasonDetail: SeasonDetail) {
        var array = arraySeasonsDetail
        array.append(seasonDetail)
        arraySeasonsDetail = array.sorted(by: { (season1, season2) -> Bool in
            guard let seasonNumber1 = season1.seasonNumber, let seasonNumber2 = season2.seasonNumber else {
                return true
            }
            return seasonNumber1 < seasonNumber2
        }).shiftRight()
    }
    
    private func trackUserShows() {
        userShowTracked = Singleton.shared.arrayUserShows.filter { $0.showId == tvShowDetail.id }.first
        
        guard let season = userShowTracked?.season, let episode = userShowTracked?.episode else {
            return
        }
        
        didSelectEpisode(at: season, row: episode > 0 ? episode - 1 : episode)
    }
    
    func sectionTitle(at section: Int) -> String? {
        return arraySeasonsDetail[section].name
    }
    
    func numberOfEpisodes(at section: Int) -> Int? {
        return arraySeasonsDetail[section].episodes?.count
    }
    
    func didSelectEpisode(at section: Int, row: Int) {
        guard let episodes = arraySeasonsDetail[section].episodes else {
            return
        }
        
        if section > 0 {
            didSelectEpisode(at: section - 1, row: arraySeasonsDetail[section - 1].episodes?.count ?? 0)
        }
        
        var arrayEpisodes = [Episodes]()
        
        for i in 0...row {
            guard i < episodes.count else {
                continue
            }
            arrayEpisodes.append(episodes[i])
        }
        
        dictionarySelectedEpisodes[section] = arrayEpisodes
        delegate?.reloadData(at: section)
    }
    
    func saveTrack() {
        var season = 0
        
        for key in dictionarySelectedEpisodes.keys {
            guard key > season else {
                continue
            }
            season = key
        }
        
        guard let arrayEpisodes = dictionarySelectedEpisodes[season] else {
            return
        }
        
        let lastEpisode = arrayEpisodes.reduce(0, { $0 + ($1.episodeNumber ?? 0) })
        
        yourListServiceModel.track(show: tvShowDetail, season: season, episode: lastEpisode)
    }
    
    
    func setLastIndexPathDisplayed(_ indexPath: IndexPath, at section: Int) {
        dictionaryLastIndexPathsDisplayed[section] = indexPath
    }
    
    func lastIndexPathDisplayed(at section: Int) -> IndexPath? {
        return dictionaryLastIndexPathsDisplayed[section]
    }
    
    func trackCellViewModel(at section: Int, row: Int) -> TrackEpisodeCellViewModel? {
        guard let episodes = arraySeasonsDetail[section].episodes else {
            return nil
        }
        
        let episode = episodes[row]
        
        var isSelected = false
        if let arrayEpisodes = dictionarySelectedEpisodes[section] {
            isSelected = arrayEpisodes.filter { $0.id == episode.id }.count > 0
        }
        
        return TrackEpisodeCellViewModel(episode: episode, isSelected: isSelected)
    }
}

