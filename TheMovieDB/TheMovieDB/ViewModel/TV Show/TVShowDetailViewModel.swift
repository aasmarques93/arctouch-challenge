//
//  TVShowDetailViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

protocol TVShowDetailViewModelDelegate: ViewModelDelegate {
    func reloadVideos()
    func reloadSeasons()
    func reloadRecommended()
    func reloadSimilar()
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
    private var tvShow: TVShow?
    
    private var tvShowDetail: TVShowDetail? {
        didSet {
            delegate?.reloadData?()
            
            name.value = valueDescription(tvShowDetail?.originalName)
            date.value = "Last air date: \(valueDescription(tvShowDetail?.lastAirDate))"
            overview.value = valueDescription(tvShowDetail?.overview)
            genres.value = setupGenres()
            
            guard let seasons = tvShowDetail?.seasons else {
                return
            }
            arraySeasons = seasons
        }
    }
    
    var average: CGFloat? {
        guard let voteAverage = tvShowDetail?.voteAverage else {
            return nil
        }
        return CGFloat(voteAverage) / 10
    }
    
    // MARK: Videos
    private var arrayVideos = [Video]() { didSet { delegate?.reloadVideos() } }
    var numberOfVideos: Int { return arrayVideos.count }
    
    // MARK: Recommended
    private var arrayRecommended = [TVShow]() { didSet { delegate?.reloadRecommended() } }
    var numberOfRecommended: Int { return arrayRecommended.count }
    
    // MARK: Similar
    private var arraySimilar = [TVShow]() { didSet { delegate?.reloadSimilar() } }
    var numberOfSimilar: Int { return arraySimilar.count }
    
    // MARK: Seasons
    private var arraySeasons = [Seasons]() { didSet { delegate?.reloadSeasons() } }
    var numberOfSeasons: Int { return arraySeasons.count }
    
    // MARK: Cast
    private var arrayCast = [Cast]() { didSet { delegate?.reloadCast() } }
    var numberOfCastCharacters: Int { return arrayCast.count }
    
    // MARK: - Life cycle -
    
    init(_ object: TVShow?) {
        self.tvShow = object
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        getTvShowDetail()
        getVideos()
        getRecommended()
        getSimilar()
        getCredits()
    }
    
    private func getTvShowDetail() {
        guard let tvShow = tvShow else {
            return
        }
        
        Loading.shared.start()
        serviceModel.getDetail(from: tvShow) { [weak self] (object) in
            Loading.shared.stop()
            self?.tvShowDetail = object as? TVShowDetail
        }
    }
    
    private func getVideos() {
        guard let tvShow = tvShow, arrayVideos.isEmpty else {
            return
        }
        
        serviceModel.getVideos(from: tvShow) { [weak self] (object) in
            guard let object = object as? VideosList, let results = object.results else {
                return
            }
            
            self?.arrayVideos.append(contentsOf: results)
        }
    }
    
    private func getRecommended() {
        guard let tvShow = tvShow, arrayRecommended.isEmpty else {
            return
        }
        
        serviceModel.getRecommendations(from: tvShow) { [weak self] (object) in
            guard let object = object as? SearchTV, let results = object.results else {
                return
            }
            
            self?.arrayRecommended.append(contentsOf: results)
        }
    }
    
    private func getSimilar() {
        guard let tvShow = tvShow, arraySimilar.isEmpty else {
            return
        }
        
        serviceModel.getSimilar(from: tvShow) { [weak self] (object) in
            guard let object = object as? SearchTV, let results = object.results else {
                return
            }
            
            self?.arraySimilar.append(contentsOf: results)
        }
    }
    
    private func getCredits() {
        guard let tvShow = tvShow, arrayCast.isEmpty else {
            return
        }
        
        serviceModel.getCredits(from: tvShow) { [weak self] (object) in
            guard let object = object as? CreditsList, let results = object.cast else {
                return
            }
            
            self?.arrayCast.append(contentsOf: results)
        }
    }
    
    // MARK: - View Model -
    
    var tvShowName: String? {
        return tvShowDetail?.originalName
    }
    
    private func setupGenres() -> String {
        var string = ""
        if let array = tvShowDetail?.genres {
            let arrayNames = array.map { valueDescription($0.name) }
            string = arrayNames.joined(separator: ", ")
        }
        return string
    }
    
    func tvShowDetailImageData(handlerData: @escaping HandlerObject) {
        loadImageData(at: tvShowDetail?.backdropPath, handlerData: handlerData)
    }
    
    // MARK: Videos
    
    func videoTitle(at index: Int) -> String? {
        return arrayVideos[index].name
    }
    
    func videoYouTubeId(at index: Int) -> String? {
        return arrayVideos[index].key
    }
    
    // MARK: Season
    
    func seasonName(at index: Int) -> String? {
        return arraySeasons[index].name
    }
    
    func seasonYear(at index: Int) -> String? {
        guard let date = Date(fromString: valueDescription(arraySeasons[index].airDate), format: DateFormatType.isoDate) else {
            return nil
        }
        return "\(date.toString(format: .isoYear)) | "
    }
    
    func seasonEpisodeCount(at index: Int) -> String? {
        return "\(valueDescription(arraySeasons[index].episodeCount)) Episodes"
    }
    
    func seasonOverview(at index: Int) -> String? {
        return arraySeasons[index].overview
    }
    
    func seasonImageData(at index: Int, handlerData: @escaping HandlerObject) {
        loadImageData(at: arraySeasons[index].posterPath, handlerData: handlerData)
    }
    
    // MARK: Recommendations
    
    func recommendedImageData(at index: Int, handlerData: @escaping HandlerObject) {
        var tvShow = arrayRecommended[index]
        
        if let data = tvShow.imageData {
            handlerData(data)
            return
        }
        
        serviceModel.loadImage(path: tvShow.posterPath ?? "", handlerData: { (data) in
            tvShow.imageData = data as? Data
            handlerData(data)
        })
    }
    
    // MARK: Cast
    
    func castImageData(at index: Int, handlerData: @escaping HandlerObject) {
        let cast = arrayCast[index]
        
        if let data = cast.imageData {
            handlerData(data)
            return
        }
        
        loadImageData(at: cast.profilePath) { [weak self] (data) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.arrayCast[index].imageData = data as? Data
            handlerData(data)
        }
    }
    
    func castName(at index: Int) -> String {
        return arrayCast[index].name ?? ""
    }
    
    func castCharacter(at index: Int) -> String {
        return arrayCast[index].character ?? ""
    }
    
    // MARK: Similar
    
    func similarImageData(at index: Int, handlerData: @escaping HandlerObject) {
        var tvShow = arraySimilar[index]
        
        if let data = tvShow.imageData {
            handlerData(data)
            return
        }
        
        serviceModel.loadImage(path: tvShow.posterPath ?? "", handlerData: { (data) in
            tvShow.imageData = data as? Data
            handlerData(data)
        })
    }
    
    // MARK: - View Model instantiation -
    
    func seasonDetailViewModel(at index: Int) -> SeasonDetailViewModel? {
        return SeasonDetailViewModel(tvShowDetail, season: arraySeasons[index])
    }
    
    func personViewModel(at index: Int) -> PersonViewModel? {
        return PersonViewModel(arrayCast[index].id)
    }
    
    func recommendedDetailViewModel(at index: Int) -> TVShowDetailViewModel? {
        return tvShowDetailViewModel(arrayRecommended[index])
    }
    
    func similarDetailViewModel(at index: Int) -> TVShowDetailViewModel? {
        return tvShowDetailViewModel(arraySimilar[index])
    }
    
    private func tvShowDetailViewModel(_ tvShow: TVShow) -> TVShowDetailViewModel? {
        return TVShowDetailViewModel(tvShow)
    }
    
}
