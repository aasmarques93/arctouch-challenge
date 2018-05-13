//
//  TVShowViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

protocol TVShowViewModelDelegate: ViewModelDelegate {
    func reloadData(at index: Int)
}

class TVShowViewModel: ViewModel {
    // MARK: - Enums -
    
    enum GenreType: String {
        case sugested = "Sugested"
        case airingToday = "Airing today"
        case onTheAir = "On the air"
        case popular = "Popular"
        case topRated = "Top Rated"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
        
        var index: Int {
            switch self {
            case .sugested:
                return 0
            case .airingToday:
                return 1
            case .onTheAir:
                return 2
            case .popular:
                return 3
            case .topRated:
                return 4
            }
        }
        
        static func genre(at index: Int) -> GenreType? {
            switch index {
            case 0:
                return GenreType.sugested
            case 1:
                return GenreType.airingToday
            case 2:
                return GenreType.onTheAir
            case 3:
                return GenreType.popular
            case 4:
                return GenreType.topRated
            default:
                return nil
            }
        }
    }
    
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: TVShowViewModelDelegate?
    
    // MARK: Service Model
    let serviceModel = TVShowServiceModel()
    
    // MARK: Genres
    private var arrayGenres: [GenreType] = [.sugested, .airingToday, .onTheAir, .popular, .topRated]
    var numberOfGenres: Int { return arrayGenres.count }
    
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
    
    // MARK: Variables
    private var isDataLoading = false
    
    // MARK: - Service requests -
    
    func loadData() {
        getTVShows(genre: .airingToday)
        getTVShows(genre: .onTheAir)
        getTVShows(genre: .popular)
        getTVShows(genre: .topRated)
    }
    
    private func loadData(genre: GenreType?) {
        guard let genre = genre else {
            return
        }
        
        switch genre {
        case .sugested:
            return
        case .airingToday:
            currentAiringTodayPage += 1
        case .onTheAir:
            currentOnTheAirPage += 1
        case .popular:
            currentPopularPage += 1
        case .topRated:
            currentTopRatedPage += 1
        }
        
        getTVShows(genre: genre)
    }
    
    private func getTVShows(genre: GenreType) {
        guard let requestUrl = getRequestUrl(with: genre) else {
            return
        }
        
        var currentPage = getCurrentPage(at: genre)
        
        isDataLoading = true
        
        let parameters: [String: Any] = [
            "page": currentPage,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        serviceModel.getTVShow(requestUrl: requestUrl, urlParameters: parameters) { [weak self] (object) in
            if let object = object as? SearchTV {
                do {
                    try self?.showError(with: object)
                } catch {
                    if let error = error as? Error {
                        self?.delegate?.showError?(message: error.message)
                    }
                    return
                }
                
                if let results = object.results {
                    self?.addTVShowsToArray(results, genre: genre)
                    currentPage += 1
                }
            }
            
            self?.reloadData(at: genre.index)
        }
    }
    
    private func getRequestUrl(with genre: GenreType) -> RequestUrl? {
        switch genre {
        case .sugested:
            return nil
        case .airingToday:
            return .tvAiringToday
        case .onTheAir:
            return .tvOnTheAir
        case .popular:
            return .tvPopular
        case .topRated:
            return .tvTopRated
        }
    }
    
    private func getCurrentPage(at genre: GenreType) -> Int {
        switch genre {
        case .sugested:
            return 0
        case .airingToday:
            return currentAiringTodayPage
        case .onTheAir:
            return currentOnTheAirPage
        case .popular:
            return currentPopularPage
        case .topRated:
            return currentTopRatedPage
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
                return genreIds.contains { return $0 == id }
            }
            let result = self?.arraySugested.contains {
                let id = $0.id
                let map = array.map { return $0.id }
                return map.contains { return $0 == id }
            }
            guard let contains = result, !contains else {
                return
            }
            self?.arraySugested.append(contentsOf: array)
        }
    }
    
    private func addTVShowsToArray(_ results: [TVShow], genre: GenreType) {
        switch genre {
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
        }
        
        addTVShowsToSugested(results)
    }
    
    private func reloadData(at index: Int) {
        delegate?.reloadData(at: index)
        isDataLoading = false
    }
    
    // MARK: - Genre methods -
    
    func genreTitle(at section: Int) -> String {
        guard let genre = GenreType.genre(at: section) else {
            return ""
        }
        guard genre == .sugested,
            let userPersonalityType = Singleton.shared.userPersonalityType,
            let title = userPersonalityType.title else {
                
                return "  \(genre.localized)"
        }
        return "  \(genre.localized) for \(title)"
    }
    
    // MARK: - TV Show methods -
    
    func numberOfTVShows(at section: Int) -> Int {
        guard let genre = GenreType.genre(at: section) else {
            return 0
        }
        switch genre {
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
        return URL(string: serviceModel.imageUrl(with: tvShow.posterPath))
    }
    
    private func getTVShowsArray(at section: Int) -> [TVShow]? {
        guard let genre = GenreType.genre(at: section) else {
            return nil
        }
        switch genre {
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
        }
    }
    
    func doServicePaginationIfNeeded(at section: Int, row: Int) {
        guard let results = getTVShowsArray(at: section) else {
            return
        }
        
        if row == results.count-2 && !isDataLoading {
            loadData(genre: GenreType.genre(at: section))
        }
    }
    
    //MARK: Detail view model
    
    func tvShowDetailViewModel(at section: Int, row: Int) -> TVShowDetailViewModel? {
        guard let tvShow = tvShow(at: section, row: row) else {
            return nil
        }
        return TVShowDetailViewModel(tvShow)
    }
    
    func searchResultViewModel(with text: String?) -> SearchResultViewModel? {
        return SearchResultViewModel(searchText: text)
    }
}
