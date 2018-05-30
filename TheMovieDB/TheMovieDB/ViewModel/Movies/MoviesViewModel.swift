//
//  MoviesViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class MoviesViewModel: MoviesShowsViewModel {
    // MARK: - Properties -
    
    // MARK: Suggested
    private var arraySuggestedMovies = [Movie]() { didSet { delegate?.reloadData?() } }
    var numberOfSuggestedMovies: Int { return arraySuggestedMovies.count }
    
    // MARK: Now Playing
    private var arrayNowPlayingMovies = [Movie]()
    var numberOfNowPlayingMovies: Int { return arrayNowPlayingMovies.count }
    private var currentNowPlayingMoviesPage: Int = 1
    
    // MARK: Upcoming movies
    private var arrayUpcomingMovies = [Movie]()
    var numberOfUpcomingMovies: Int { return arrayUpcomingMovies.count }
    private var currentUpcomingMoviesPage: Int = 1
    
    // MARK: Top rated
    private var arrayTopRatedMovies = [Movie]()
    var numberOfTopRatedMovies: Int { return arrayTopRatedMovies.count }
    private var currentTopRatedMoviesPage: Int = 1
    
    // MARK: Popular
    private var arrayPopularMovies = [Movie]()
    var numberOfPopularMovies: Int { return arrayPopularMovies.count }
    private var currentPopularMoviesPage: Int = 1
    
    // MARK: Latest
    private var latestMovie: Movie? {
        didSet {
            latestTitle.value = latestMovie?.title
            getLatestImage(at: latestMovie?.backdropPath)
        }
    }
    
    // MARK: - Service requests -
    
    override func loadData() {
        super.loadData()
        getMovies(section: .popular)
        getMovies(section: .topRated)
        getMovies(section: .upcoming)
        getMovies(section: .nowPlaying)
    }
    
    private func loadData(section: SectionsType?) {
        guard let section = section else {
            return
        }
        
        switch section {
        case .popular:
            currentPopularMoviesPage += 1
        case .topRated:
            currentTopRatedMoviesPage += 1
        case .upcoming:
            currentUpcomingMoviesPage += 1
        case .nowPlaying:
            currentNowPlayingMoviesPage += 1
        default:
            return
        }
        
        getMovies(section: section)
    }
    
    func loadSuggestedMovies() {
        guard arraySuggestedMovies.isEmpty else {
            return
        }
        
        guard let userPersonalityType = Singleton.shared.userPersonalityType, let genres = userPersonalityType.genres else {
            return
        }
        
        genres.forEach { [weak self] (id) in
            self?.getMoviesFromGenre(id: id)
        }
    }
    
    func getMoviesFromGenre(id: Int?) {
        super.getMoviesFromGenre(id: id) { [weak self] (object) in
            guard let object = object as? SearchMoviesGenre, let results = object.results else {
                return
            }
            let result = self?.arraySuggestedMovies.contains {
                let id = $0.id
                let map = results.map { $0.id }
                return map.contains { $0 == id }
            }
            guard let contains = result, !contains else {
                return
            }
            guard let array = self?.sortedByVoteAverage(array: results) else {
                return
            }
            self?.getLatest()
            self?.addMoviesToArray(array, section: .suggested)
            self?.reloadData(at: SectionsType.suggested.index(isMovie: self?.isMovie ?? true))
        }
    }
    
    private func getLatest() {
        if latestMovie != nil {
            return
        }
        
        latestMovie = arraySuggestedMovies.randomElement()
    }
    
    private func getMovies(section: SectionsType) {
        guard let requestUrl = getRequestUrl(with: section) else {
            return
        }
        
        var currentPage = getCurrentPage(at: section)
        
        isDataLoading = true
        
        let parameters: [String: Any] = [
            "page": currentPage,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        moviesServiceModel.getMovies(urlParameters: parameters, requestUrl: requestUrl) { [weak self] (object) in
            if let object = object as? MoviesList {
                do {
                    try self?.showError(with: object)
                } catch {
                    if let error = error as? Error {
                        self?.delegate?.showAlert?(message: error.message)
                    }
                    return
                }
                
                if let results = object.results {
                    self?.addMoviesToArray(results, section: section)
                    currentPage += 1
                }
            }
            
            self?.reloadData(at: section.index(isMovie: self?.isMovie ?? true))
        }
    }
    
    private func getCurrentPage(at section: SectionsType) -> Int {
        switch section {
        case .popular:
            return currentPopularMoviesPage
        case .topRated:
            return currentTopRatedMoviesPage
        case .upcoming:
            return currentUpcomingMoviesPage
        case .nowPlaying:
            return currentNowPlayingMoviesPage
        default:
            return 0
        }
    }
    
    private func addMoviesToArray(_ results: [Movie], section: SectionsType) {
        switch section {
        case .suggested:
            arraySuggestedMovies.append(contentsOf: results)
        case .popular:
            arrayPopularMovies.append(contentsOf: results)
        case .topRated:
            arrayTopRatedMovies.append(contentsOf: results)
        case .upcoming:
            arrayUpcomingMovies.append(contentsOf: results)
        case .nowPlaying:
            arrayNowPlayingMovies.append(contentsOf: results)
        default:
            break
        }
    }
    
    // MARK: - Movie methods -
    
    func numberOfMovies(at section: Int) -> Int {
        guard let sectionType = SectionsType.section(at: section, isMovie: isMovie) else {
            return 0
        }
        switch sectionType {
        case .netflix:
            return numberOfNetflix
        case .suggested:
            return numberOfSuggestedMovies
        case .friendsWatching:
            return numberOfUserFriendsMovies
        case .popular:
            return numberOfPopularMovies
        case .topRated:
            return numberOfTopRatedMovies
        case .upcoming:
            return numberOfUpcomingMovies
        case .nowPlaying:
            return numberOfNowPlayingMovies
        default:
            return 0
        }
    }
    
    func isMoviesEmpty(at indexPath: IndexPath) -> Bool {
        return numberOfMovies(at: indexPath.section) == 0
    }
    
    private func movie(at section: Int, row: Int) -> Movie? {
        guard let results = getMoviesArray(at: section), row < results.count else {
            return nil
        }
        return results[row]
    }
    
    func imagePathUrl(at section: Int, row: Int) -> URL? {
        guard let movie = movie(at: section, row: row) else {
            return nil
        }
        return URL(string: moviesServiceModel.imageUrl(with: movie.posterPath))
    }
    
    private func getMoviesArray(at section: Int) -> [Movie]? {
        guard let sectionType = SectionsType.section(at: section, isMovie: isMovie) else {
            return nil
        }
        switch sectionType {
        case .suggested:
            return arraySuggestedMovies
        case .friendsWatching:
            return arrayUserFriendsMovies
        case .popular:
            return arrayPopularMovies
        case .topRated:
            return arrayTopRatedMovies
        case .upcoming:
            return arrayUpcomingMovies
        case .nowPlaying:
            return arrayNowPlayingMovies
        default:
            return nil
        }
    }
    
    func doServicePaginationIfNeeded(at section: Int, row: Int) {
        guard let results = getMoviesArray(at: section) else {
            return
        }
        
        if row == results.count-2 && !isDataLoading {
            loadData(section: SectionsType.section(at: section, isMovie: isMovie))
        }
    }
    
    //MARK: Detail view model
    
    func movieDetailViewModel(at section: Int, row: Int) -> MovieDetailViewModel? {
        guard let movie = movie(at: section, row: row) else {
            return nil
        }
        return MovieDetailViewModel(movie)
    }
    
    func latestMovieDetailViewModel() -> MovieDetailViewModel? {
        guard let movie = latestMovie else {
            return nil
        }
        return MovieDetailViewModel(movie)
    }
}
