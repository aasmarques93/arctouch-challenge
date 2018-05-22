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
    
    private var tvShowDetail: TVShowDetail
    private var arraySeasons: [Seasons]
    private var arraySeasonsDetail = [SeasonDetail]() { didSet { delegate?.reloadData?() } }
    var numberOfSeasons: Int { return arraySeasonsDetail.count }
    
    private var dictionarySelectedEpisodes = [Int: [Episodes]]()
    
    private var dictionaryLastIndexPathsDisplayed = [Int: IndexPath]()
    
    init(tvShowDetail: TVShowDetail, arraySeasons: [Seasons]) {
        self.tvShowDetail = tvShowDetail
        self.arraySeasons = arraySeasons
    }
    
    func loadData() {
        arraySeasons.forEach { [weak self] (season) in
            self?.loadDetailFrom(season: season)
        }
    }
    
    func loadDetailFrom(season: Seasons) {
        serviceModel.getDetail(from: tvShowDetail, season: season) { [weak self] (object) in
            guard let seasonDetail = object as? SeasonDetail, let arraySeasonsDetail = self?.arraySeasonsDetail else {
                return
            }

            var array = arraySeasonsDetail
            array.append(seasonDetail)
            self?.arraySeasonsDetail = array.sorted(by: { (season1, season2) -> Bool in
                guard let seasonNumber1 = season1.seasonNumber, let seasonNumber2 = season2.seasonNumber else {
                    return true
                }
                return seasonNumber1 < seasonNumber2
            }).shiftRight()
        }
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

