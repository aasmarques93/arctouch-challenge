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
            
            if let episodes = seasonDetail?.episodes {
                episodesList = episodes
            }
        }
    }
    
    // MARK: - Objects -
    
    var tvShowDetail: TVShowDetail?
    var season: Seasons?
    
    private var episodesList = [Episodes]() { didSet { if let method = delegate?.reloadData { method() } } }
    var numberOfEpisodes: Int { return episodesList.count }
    
    var seasonName: String? {
        return season?.name
    }
    
    // MARK: - Life cycle -
    
    init(_ object: TVShowDetail?, season: Seasons?) {
        super.init()
        self.tvShowDetail = object
        self.season = season
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        getSeasonDetail()
    }
    
    private func getSeasonDetail() {
        loadingView.startInWindow()
        serviceModel.getDetail(from: tvShowDetail, season: season) { (object) in
            self.loadingView.stop()
            self.seasonDetail = object as? SeasonDetail
        }
    }
    
    var heightForOverview: CGFloat? {
        return seasonDetail?.overview?.height
    }
    
    func heightForEpisodeOverview(at indexPath: IndexPath) -> CGFloat? {
        let episode = episodesList[indexPath.row]
        if let overview = episode.overview {
            return overview.height
        }
        return nil
    }
    
    // MARK: - View Model -
    
    func episodeViewModel(at indexPath: IndexPath) -> EpisodeViewModel? {
        return EpisodeViewModel(episodesList[indexPath.row])
    }
}
