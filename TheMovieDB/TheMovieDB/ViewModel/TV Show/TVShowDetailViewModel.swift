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
    
    // MARK: Seasons
    private var arraySeasons = [Seasons]() { didSet { delegate?.reloadSeasons() } }
    var numberOfSeasons: Int { return arraySeasons.count }
    
    // MARK: Cast
    private var arrayCast = [Cast]() { didSet { delegate?.reloadCast() } }
    var numberOfCastCharacters: Int { return arrayCast.count }
    
    // MARK: - Life cycle -
    
    init(_ id: Int?) {
        self.id = id
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        getTvShowDetail()
        getVideos()
        getCredits()
    }
    
    private func getTvShowDetail() {
        Loading.shared.start()
        serviceModel.getDetail(from: id) { [weak self] (object) in
            Loading.shared.stop()
            self?.tvShowDetail = object as? TVShowDetail
        }
    }
    
    private func getVideos() {
        if arrayVideos.isEmpty {
            serviceModel.getVideos(from: id) { [weak self] (object) in
                guard let object = object as? VideosList, let results = object.results else {
                    return
                }
                
                self?.arrayVideos.append(contentsOf: results)
            }
        }
    }
    
    private func getCredits() {
        if arrayCast.isEmpty {
            serviceModel.getCredits(from: id) { [weak self] (object) in
                guard let object = object as? CreditsList, let results = object.cast else {
                    return
                }
                
                self?.arrayCast.append(contentsOf: results)
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
    
    // MARK: - Person View Model -
    
    func personViewModel(at index: Int) -> PersonViewModel? {
        return PersonViewModel(arrayCast[index].id)
    }
    
    func seasonDetailViewModel(at index: Int) -> SeasonDetailViewModel? {
        return SeasonDetailViewModel(tvShowDetail, season: arraySeasons[index])
    }
}
