//
//  TVShowViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

class TVShowViewModel: MoviesShowsViewModel {
    // MARK: - Properties -
    
    // MARK: Sugested
    private var arraySugested = [TVShow]()
    var numberOfSugested: Int { return arraySugested.count }
    
    // MARK: Airing today
    private var arrayAiringToday = [TVShow]()
    var numberOfAiringToday: Int { return arrayAiringToday.count }
    private var currentAiringTodayPage: Int = 1
    
    // MARK: On the air
    private var arrayOnTheAir = [TVShow]()
    var numberOfOnTheAir: Int { return arrayOnTheAir.count }
    private var currentOnTheAirPage: Int = 1
    
    // MARK: Popular
    private var arrayPopular = [TVShow]()
    var numberOfPopular: Int { return arrayPopular.count }
    private var currentPopularPage: Int = 1
    
    // MARK: Top Rated
    private var arrayTopRated = [TVShow]()
    var numberOfTopRated: Int { return arrayTopRated.count }
    private var currentTopRatedPage: Int = 1
    
    // MARK: Latest
    private var latestShow: TVShow? {
        didSet {
            latestTitle.value = latestShow?.name
            getLatestImage(at: latestShow?.backdropPath)
        }
    }
    
    // MARK: - Service requests -
    
    override func loadData() {
        super.loadData()
        getTVShows(section: .airingToday)
        getTVShows(section: .onTheAir)
        getTVShows(section: .popular)
        getTVShows(section: .topRated)
    }
    
    private func loadData(section: SectionsType?) {
        guard let section = section else {
            return
        }
        
        switch section {
        case .airingToday:
            currentAiringTodayPage += 1
        case .onTheAir:
            currentOnTheAirPage += 1
        case .popular:
            currentPopularPage += 1
        case .topRated:
            currentTopRatedPage += 1
        default:
            return
        }
        
        getTVShows(section: section)
    }
    
    private func getTVShows(section: SectionsType) {
        guard let requestUrl = getRequestUrl(with: section) else {
            return
        }
        
        var currentPage = getCurrentPage(at: section)
        
        isDataLoading = true
        
        let parameters: [String: Any] = [
            "page": currentPage,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        tvShowServiceModel.getTVShow(requestUrl: requestUrl, urlParameters: parameters) { [weak self] (object) in
            if let object = object as? SearchTV {
                do {
                    try self?.showError(with: object)
                } catch {
                    if let error = error as? Error {
                        self?.delegate?.showAlert?(message: error.message)
                    }
                    return
                }
                
                if let results = object.results {
                    self?.addTVShowsToArray(results, section: section)
                    currentPage += 1
                }
            }
            
            self?.reloadData(at: section.index(isMovie: self?.isMovie ?? false))
        }
    }
    
    private func getCurrentPage(at section: SectionsType) -> Int {
        switch section {
        case .airingToday:
            return currentAiringTodayPage
        case .onTheAir:
            return currentOnTheAirPage
        case .popular:
            return currentPopularPage
        case .topRated:
            return currentTopRatedPage
        default:
            return 0
        }
    }
    
    private func addTVShowsToSugested(_ results: [TVShow]) {
        guard let userPersonalityType = Singleton.shared.userPersonalityType, let genres = userPersonalityType.genres else {
            return
        }
        
        genres.forEach { [weak self] (id) in
            let array = results.filter {
                guard let genreIds = $0.genreIds else {
                    return false
                }
                return genreIds.contains { $0 == id }
            }
            let result = self?.arraySugested.contains {
                let id = $0.id
                let map = array.map { $0.id }
                return map.contains { $0 == id }
            }
            guard let contains = result, !contains else {
                return
            }
            self?.arraySugested.append(contentsOf: array)
        }
        
        getLatest()
    }
    
    private func getLatest() {
        if latestShow != nil {
            return
        }
        
        latestShow = arraySugested.randomElement()
    }
    
    private func addTVShowsToArray(_ results: [TVShow], section: SectionsType) {
        switch section {
        case .sugested:
            break
        case .airingToday:
            arrayAiringToday.append(contentsOf: results)
        case .onTheAir:
            arrayOnTheAir.append(contentsOf: results)
        case .popular:
            arrayPopular.append(contentsOf: results)
        case .topRated:
            arrayTopRated.append(contentsOf: results)
        default:
            return
        }
        
        addTVShowsToSugested(results)
    }
    
    // MARK: - TV Show methods -
    
    func numberOfTVShows(at section: Int) -> Int {
        guard let sectionType = SectionsType.section(at: section, isMovie: isMovie) else {
            return 0
        }
        switch sectionType {
        case .netflix:
            return numberOfNeflix
        case .sugested:
            return numberOfSugested
        case .airingToday:
            return numberOfAiringToday
        case .onTheAir:
            return numberOfOnTheAir
        case .popular:
            return numberOfPopular
        case .topRated:
            return numberOfTopRated
        default:
            return 0
        }
    }
    
    func isTVShowEmpty(at indexPath: IndexPath) -> Bool {
        return numberOfTVShows(at: indexPath.section) == 0
    }
    
    private func tvShow(at section: Int, row: Int) -> TVShow? {
        guard let results = getTVShowsArray(at: section), row < results.count else {
            return nil
        }
        return results[row]
    }
    
    func imagePathUrl(at section: Int, row: Int) -> URL? {
        guard let tvShow = tvShow(at: section, row: row) else {
            return nil
        }
        return URL(string: tvShowServiceModel.imageUrl(with: tvShow.posterPath))
    }
    
    private func getTVShowsArray(at section: Int) -> [TVShow]? {
        guard let sectionType = SectionsType.section(at: section, isMovie: isMovie) else {
            return nil
        }
        switch sectionType {
        case .sugested:
            return arraySugested
        case .airingToday:
            return arrayAiringToday
        case .onTheAir:
            return arrayOnTheAir
        case .popular:
            return arrayPopular
        case .topRated:
            return arrayTopRated
        default:
            return nil
        }
    }
    
    func doServicePaginationIfNeeded(at section: Int, row: Int) {
        guard let results = getTVShowsArray(at: section) else {
            return
        }
        
        if row == results.count-2 && !isDataLoading {
            loadData(section: SectionsType.section(at: section, isMovie: isMovie))
        }
    }
    
    //MARK: Detail view model
    
    func tvShowDetailViewModel(at section: Int, row: Int) -> TVShowDetailViewModel? {
        guard let tvShow = tvShow(at: section, row: row) else {
            return nil
        }
        return TVShowDetailViewModel(tvShow)
    }
    
    func latestTVShowDetailViewModel() -> TVShowDetailViewModel? {
        guard let tvShow = latestShow else {
            return nil
        }
        return TVShowDetailViewModel(tvShow)
    }
}
