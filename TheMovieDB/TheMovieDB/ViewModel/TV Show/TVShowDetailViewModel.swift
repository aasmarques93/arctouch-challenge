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
    var rateResult = Observable<String>(Titles.rate.localized)
    
    var rateValue: Float? {
        guard let value = Float(rateResult.value) else {
            return nil
        }
        return value
    }
    
    // MARK: Objects
    private var tvShow: TVShow
    
    private var tvShowDetail: TVShowDetail? {
        didSet {
            delegate?.reloadData?()
            
            name.value = valueDescription(tvShowDetail?.originalName)
            date.value = valueDescription(tvShowDetail?.lastAirDate)
            overview.value = valueDescription(tvShowDetail?.overview)
            genres.value = setupGenres()
            
            guard let seasons = tvShowDetail?.seasons else {
                return
            }
            
            arraySeasons = seasons.shiftRight()
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
    
    init(_ object: TVShow) {
        self.tvShow = object
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        setupRating()
        getTvShowDetail()
        getVideos()
        getRecommended()
        getSimilar()
        getCredits()
    }
    
    private func getTvShowDetail() {
        Loading.shared.start()
        serviceModel.getDetail(from: tvShow) { [weak self] (object) in
            Loading.shared.stop()
            self?.tvShowDetail = object
        }
    }
    
    private func getVideos() {
        guard arrayVideos.isEmpty else {
            return
        }
        
        serviceModel.getVideos(from: tvShow) { [weak self] (object) in
            guard let results = object.results else {
                return
            }
            
            self?.arrayVideos.append(contentsOf: results)
        }
    }
    
    private func getRecommended() {
        guard arrayRecommended.isEmpty else {
            return
        }
        
        serviceModel.getRecommendations(from: tvShow) { [weak self] (object) in
            guard let results = object.results else {
                return
            }
            
            self?.arrayRecommended.append(contentsOf: results)
        }
    }
    
    private func getSimilar() {
        guard arraySimilar.isEmpty else {
            return
        }
        
        serviceModel.getSimilar(from: tvShow) { [weak self] (object) in
            guard let results = object.results else {
                return
            }
            
            self?.arraySimilar.append(contentsOf: results)
        }
    }
    
    private func getCredits() {
        guard arrayCast.isEmpty else {
            return
        }
        
        serviceModel.getCredits(from: tvShow) { [weak self] (object) in
            guard let results = object.cast else {
                return
            }
            
            self?.arrayCast.append(contentsOf: results)
        }
    }
    
    func rateShow() {
        guard let value = rateValue else {
            return
        }
        serviceModel.rate(tvShow: tvShow, value: value) { (object) in
            Singleton.shared.loadUserData()
        }
    }
    
    // MARK: - View Model -
    
    // MARK: Appearance
    
    private func setupRating() {
        let ratings = Singleton.shared.arrayUserRatings.filter { $0.showId == tvShow.id }
        guard let userRating = ratings.first, let rate = userRating.rate else {
            return
        }
        rateResult.value = "\(rate)"
    }
    
    // MARK: Rating
    
    func setRateResultValue(_ value: Float) {
        rateResult.value = "\(value)"
    }
    
    // MARK: TV Show
    
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
        guard let tvShowDetail = tvShowDetail else {
            return
        }
        
        Singleton.shared.serviceModel.loadImage(path: tvShowDetail.backdropPath, handlerData: { (data) in
            handlerData(data)
        })
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
    
    func seasonImageUrl(at index: Int) -> URL? {
        return URL(string: Singleton.shared.serviceModel.imageUrl(with: arraySeasons[index].posterPath ?? ""))
    }
    
    // MARK: Recommendations
    
    func recommendedImageUrl(at index: Int) -> URL? {
        let tvShow = arrayRecommended[index]
        return URL(string: Singleton.shared.serviceModel.imageUrl(with: tvShow.posterPath ?? ""))
    }
    
    // MARK: Cast
    
    func castImageUrl(at index: Int) -> URL? {
        let cast = arrayCast[index]
        return URL(string: Singleton.shared.serviceModel.imageUrl(with: cast.profilePath ?? ""))
    }
    
    func castName(at index: Int) -> String {
        return arrayCast[index].name ?? ""
    }
    
    func castCharacter(at index: Int) -> String {
        return arrayCast[index].character ?? ""
    }
    
    // MARK: Similar
    
    func similarImageUrl(at index: Int) -> URL? {
        let tvShow = arraySimilar[index]
        return URL(string: Singleton.shared.serviceModel.imageUrl(with: tvShow.posterPath ?? ""))
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
    
    func trackViewModel() -> TrackViewModel? {
        guard let tvShowDetail = tvShowDetail else {
            return nil
        }
        return TrackViewModel(tvShowDetail: tvShowDetail, arraySeasons: arraySeasons)
    }
}
