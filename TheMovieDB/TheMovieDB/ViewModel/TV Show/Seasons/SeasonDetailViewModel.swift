//
//  SeasonDetailViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/30/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class SeasonDetailViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: ViewModelDelegate?
    
    // MARK: Service Model
    let serviceModel = SeasonDetailServiceModel()
    
    // MARK: Observables
    var name = Observable<String?>(nil)
    var overview = Observable<String?>(nil)
    
    private var id: Int!
    
    private var seasonDetail: SeasonDetail? {
        didSet {
            overview.value = valueDescription(seasonDetail?.overview)
            
            guard let episodes = seasonDetail?.episodes else {
                return
            }
            
            arrayEpisodes = episodes
        }
    }
    
    // MARK: - Objects -
    
    var tvShowDetail: TVShowDetail?
    var season: Seasons?
    
    private var arrayEpisodes = [Episodes]() { didSet { delegate?.reloadData?() } }
    var numberOfEpisodes: Int { return arrayEpisodes.count }
    
    var seasonName: String? {
        return season?.name
    }

    // MARK: - Life cycle -
    
    init(_ object: TVShowDetail?, season: Seasons?) {
        self.tvShowDetail = object
        self.season = season
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        if seasonDetail != nil { return }

        Loading.shared.start()
        serviceModel.getDetail(from: tvShowDetail, season: season) { [weak self] (object) in
            Loading.shared.stop()
            self?.seasonDetail = object as? SeasonDetail
        }
    }
    
    var heightForOverview: CGFloat? {
        return seasonDetail?.overview?.height
    }
    
    func heightForEpisodeOverview(at indexPath: IndexPath) -> CGFloat? {
        let episode = arrayEpisodes[indexPath.row]
        guard let overview = episode.overview else {
            return nil
        }
        return overview.height + 32
    }
    
    // MARK: - View Model -
    
    func episodeViewModel(at indexPath: IndexPath) -> EpisodeViewModel? {
        return EpisodeViewModel(arrayEpisodes[indexPath.row], tvShowDetail: tvShowDetail)
    }
}