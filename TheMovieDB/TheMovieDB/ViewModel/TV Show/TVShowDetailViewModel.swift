//
//  TVShowDetailViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

protocol TVShowDetailViewModelDelegate: class {
    func reloadData()
    func reloadVideos()
    func reloadSeasons()
    func reloadCast()
}

class TVShowDetailViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: TVShowDetailViewModelDelegate?
    
    // MARK: Service Model
    let serviceModel = TVShowDetailServiceModel()
    
    // MARK: Observables
    var name = Observable<String?>(nil)
    var date = Observable<String?>(nil)
    var genres = Observable<String?>(nil)
    var overview = Observable<String?>(nil)
    
    // MARK: Objects
    private var id: Int!
    
    private var tvShowDetail: TVShowDetail? {
        didSet {
            delegate?.reloadData()
            
            name.value = valueDescription(tvShowDetail?.originalName)
            date.value = "Last air date: \(valueDescription(tvShowDetail?.lastAirDate))"
            overview.value = valueDescription(tvShowDetail?.overview)
            genres.value = setupGenres()
            
            if let seasons = tvShowDetail?.seasons { seasonsList = seasons }
        }
    }
    
    var average: CGFloat? {
        if let voteAverage = tvShowDetail?.voteAverage { return CGFloat(voteAverage) / 10 }
        return nil
    }
    
    // MARK: Videos
    private var videosList = [Video]() { didSet { delegate?.reloadVideos() } }
    var numberOfVideos: Int { return videosList.count }
    
    // MARK: Seasons
    private var seasonsList = [Seasons]() { didSet { delegate?.reloadSeasons() } }
    var numberOfSeasons: Int { return seasonsList.count }
    
    // MARK: Cast
    private var castList = [Cast]() { didSet { delegate?.reloadCast() } }
    var numberOfCastCharacters: Int { return castList.count }
    
    // MARK: - Life cycle -
    
    init(_ id: Int?) {
        super.init()
        self.id = id
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        getTvShowDetail()
        getVideos()
        getCredits()
    }
    
    private func getTvShowDetail() {
        loadingView.startInWindow()
        serviceModel.getDetail(from: id) { (object) in
            self.loadingView.stop()
            self.tvShowDetail = object as? TVShowDetail
        }
    }
    
    private func getVideos() {
        if videosList.isEmpty {
            serviceModel.getVideos(from: id) { (object) in
                if let object = object as? VideosList, let results = object.results {
                    self.videosList.append(contentsOf: results)
                }
            }
        }
    }
    
    private func getCredits() {
        if castList.isEmpty {
            serviceModel.getCredits(from: id) { (object) in
                if let object = object as? CreditsList, let results = object.cast {
                    self.castList.append(contentsOf: results)
                }
            }
        }
    }
    
    // MARK: - View Model -
    
    var tvShowName: String? {
        return tvShowDetail?.originalName
    }
    
    private func setupGenres() -> String {
        var string = ""
        if let array = tvShowDetail?.genres {
            let arrayNames = array.map { return valueDescription($0.name) }
            string = arrayNames.joined(separator: ", ")
        }
        return string
    }
    
    func tvShowDetailImageData(handlerData: @escaping HandlerObject) {
        loadImageData(at: tvShowDetail?.backdropPath, handlerData: handlerData)
    }
    
    private func loadImageData(at path: String?, handlerData: @escaping HandlerObject) {
        serviceModel.loadImage(path: path, handlerData: { (data) in
            handlerData(data)
        })
    }
    
    // MARK: Videos
    
    func videoTitle(at index: Int) -> String? {
        return videosList[index].name
    }
    
    func videoYouTubeId(at index: Int) -> String? {
        return videosList[index].key
    }
    
    // MARK: Season
    
    func seasonName(at index: Int) -> String? {
        return seasonsList[index].name
    }
    
    func seasonYear(at index: Int) -> String? {
        if let date = Date(fromString: valueDescription(seasonsList[index].airDate), format: DateFormatType.isoDate) {
            return "\(date.toString(format: .isoYear)) | "
        }
        return nil
    }
    
    func seasonEpisodeCount(at index: Int) -> String? {
        return "\(valueDescription(seasonsList[index].episodeCount)) Episodes"
    }
    
    func seasonOverview(at index: Int) -> String? {
        return seasonsList[index].overview
    }
    
    func seasonImageData(at index: Int, handlerData: @escaping HandlerObject) {
        loadImageData(at: seasonsList[index].posterPath, handlerData: handlerData)
    }
    
    // MARK: Cast
    
    func castImageData(at index: Int, handlerData: @escaping HandlerObject) {
        let cast = castList[index]
        
        if let data = cast.imageData {
            handlerData(data)
            return
        }
        
        loadImageData(at: cast.profilePath) { (data) in
            cast.imageData = data as? Data
            handlerData(data)
        }
    }
    
    func castName(at index: Int) -> String {
        return castList[index].name ?? ""
    }
    
    func castCharacter(at index: Int) -> String {
        return castList[index].character ?? ""
    }
    
    // MARK: - Person View Model -
    
    func personViewModel(at index: Int) -> PersonViewModel? {
        return PersonViewModel(castList[index].id)
    }
}
