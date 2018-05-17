//
//  RouletteViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/15/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class RouletteViewModel: ViewModel {
    // MARK: Delegate
    weak var delegate: ViewModelDelegate?
    
    // MARK: Service Model
    let serviceModel = NetflixServiceModel()
    
    // MARK: Enum
    
    enum PickerType: Int {
        case genres = 0
        case imdb = 1
        case rottenTomatoes = 2
        
        var title: String? {
            switch self {
            case .genres:
                return "Genres"
            case .imdb:
                return "IMDB"
            case .rottenTomatoes:
                return "Rotten Tomates"
            }
        }
        
        var message: String? {
            switch self {
            case .genres:
                return "Select the genre type"
            case .imdb:
                return "Select the IMDB minimal score"
            case .rottenTomatoes:
                return "Select the Rotten Tomates minimal score"
            }
        }
    }
    
    // MARK: Observable
    var genres = Observable<String?>(nil)
    var imdb = Observable<String?>(nil)
    var rottenTomatoes = Observable<String?>(nil)
    
    var isMoviesOn = Observable<Bool>(true)
    var isTVShowsOn = Observable<Bool>(true)
    
    var isLabelMessageHidden = Observable<Bool>(false)
    var isViewResultHidden = Observable<Bool>(true)
    
    var titleResult = Observable<String?>(nil)
    var dateResult = Observable<String?>(nil)
    var movieShowType = Observable<String?>(nil)
    var imdbResult = Observable<String?>(nil)
    var rottenTomatoesResult = Observable<String?>(nil)
    var overviewResult = Observable<String?>(nil)
    
    private var arrayGenres: [String] {
        var array = [Titles.allGenres.localized]
        let genres = Singleton.shared.arrayNetflixGenres.map { $0.name ?? "" }
        array.append(contentsOf: genres)
        return array
    }
    
    private var arrayIMDB = [Titles.anyScore.localized]
    private var arrayRottenTomatoes = [Titles.anyScore.localized]
    
    private var netflixRandomRoulette: Netflix? {
        didSet {
            isLabelMessageHidden.value = true
            isViewResultHidden.value = false
            
            titleResult.value = netflixRandomRoulette?.title
            imdbResult.value = "\(netflixRandomRoulette?.imdbRating ?? 0)"
            rottenTomatoesResult.value = "\(netflixRandomRoulette?.rtCriticsRating ?? 0)%"
            if let value = netflixRandomRoulette?.releasedOn {
                dateResult.value = Date(fromString: value, format: .custom(Constants.dateFormatIsoTime))?.toString(format: .isoDate)
            }
            movieShowType.value = isMovie ? Titles.movie.localized : Titles.tvShow.localized
            
            loadDetailNetflix()
            
            delegate?.reloadData?()
        }
    }
    
    private var netflixMovieShow: NetflixMovieShow?
    
    var imageResultUrl: URL? {
        return URL(string: serviceModel.imageUrl(with: netflixRandomRoulette?.id, isMovie: isMovie))
    }
    
    var videoKey: String? {
        return netflixMovieShow?.trailer?.key
    }
    
    private var isMovie: Bool {
        return netflixRandomRoulette?.contentType == "m"
    }
    
    init() {
        getNetflixGenres()
        
        for i in 5..<10 {
            arrayIMDB.append("> \(i)")
            arrayRottenTomatoes.append("> \(i * 10)%")
        }
    }
    
    func loadData() {
        if genres.value == nil { genres.value = arrayGenres.first ?? "" }
        if imdb.value == nil { imdb.value = arrayIMDB.first }
        if rottenTomatoes.value == nil { rottenTomatoes.value = arrayRottenTomatoes.first }
    }
    
    private func getNetflixGenres() {
        serviceModel.getNetflixGenres { [weak self] (object) in
            guard let results = object as? [Genres] else {
                return
            }
            
            Singleton.shared.arrayNetflixGenres = results
        }
    }
    
    private func loadDetailNetflix() {
        guard let movieShow = netflixRandomRoulette else {
            return
        }
        
        serviceModel.getNetflixDetail(movieShow: movieShow, isMovie: isMovie) { [weak self] (object) in
            self?.netflixMovieShow = object as? NetflixMovieShow
            self?.overviewResult.value = self?.netflixMovieShow?.overview
        }
    }
    
    func pickerTitle(at index: Int) -> String? {
        guard let type = PickerType(rawValue: index) else {
            return nil
        }
        return type.title
    }
    
    func pickerMessage(at index: Int) -> String? {
        guard let type = PickerType(rawValue: index) else {
            return nil
        }
        return type.message
    }
    
    func pickerValues(at index: Int) -> [[String]] {
        guard let type = PickerType(rawValue: index) else {
            return []
        }
        
        var array = [[String]]()
        
        switch type {
        case .genres:
            array.append(arrayGenres)
        case .imdb:
            array.append(arrayIMDB)
        case .rottenTomatoes:
            array.append(arrayRottenTomatoes)
        }
        
        return array
    }
    
    func didSelectPickerItem(at row: Int, selectedIndex: Int?) {
        guard let selectedIndex = selectedIndex, let type = PickerType(rawValue: row) else {
            return
        }
        
        switch type {
        case .genres:
            genres.value = arrayGenres[selectedIndex]
        case .imdb:
            imdb.value = arrayIMDB[selectedIndex]
        case .rottenTomatoes:
            rottenTomatoes.value = arrayRottenTomatoes[selectedIndex]
        }
    }
    
    func doSpin() {
        let genres = Singleton.shared.arrayNetflixGenres.filter { $0.name == self.genres.value }
        let imdb = self.imdb.value?.onlyNumbers ?? ""
        let rottenTomatoes = self.rottenTomatoes.value?.onlyNumbers ?? ""
        
        Loading.shared.start()
        serviceModel.doSpin(genre: genres.first,
                            isMovieOn: isMoviesOn.value,
                            isTVShowOn: isTVShowsOn.value,
                            imdb: Int(imdb),
                            rottenTomatoes: Int(rottenTomatoes)) { [weak self] (object) in
                                
                                Loading.shared.stop()
                                
                                guard let results = object as? [Netflix] else {
                                    return
                                }
                                
                                guard results.count > 0 else {
                                    self?.delegate?.showError?(message: Messages.movieShowNotFound.localized)
                                    return
                                }
                                
                                self?.netflixRandomRoulette = results.randomElement()
        }
    }
}
