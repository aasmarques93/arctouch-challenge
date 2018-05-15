//
//  MoviesViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

protocol MoviesViewModelDelegate: ViewModelDelegate {
    func reloadData(at index: Int)
    func openPreview(storiesViewModel: StoriesViewModel)
}

class MoviesViewModel: ViewModel {
    // MARK: - Enums -
    
    enum GenreType: String {
        case netflix = "Watch on Netflix"
        case sugested = "Sugested"
        case nowPlaying = "Now Playing"
        case topRated = "Top Rated"
        case upcoming = "Upcoming"
        case popular = "Popular"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
        
        var index: Int {
            switch self {
            case .netflix:
                return 0
            case .sugested:
                return 1
            case .popular:
                return 2
            case .topRated:
                return 3
            case .upcoming:
                return 4
            case .nowPlaying:
                return 5
            }
        }
        
        static func genre(at index: Int) -> GenreType? {
            switch index {
            case 0:
                return GenreType.netflix
            case 1:
                return GenreType.sugested
            case 2:
                return GenreType.popular
            case 3:
                return GenreType.topRated
            case 4:
                return GenreType.upcoming
            case 5:
                return GenreType.nowPlaying
            default:
                return nil
            }
        }
    }
    
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: MoviesViewModelDelegate?
    
    // MARK: Service Model
    let serviceModel = MoviesServiceModel()
    let netflixServiceModel = NetflixServiceModel()
    
    // MARK: Genres
    private var arrayGenres: [GenreType] = [.netflix, .sugested, .popular, .topRated, .upcoming, .nowPlaying]
    var numberOfGenres: Int { return arrayGenres.count }
    
    // MARK: Sugested
    private var arraySugestedMovies = [Movie]() { didSet { delegate?.reloadData?() } }
    var numberOfSugestedMovies: Int { return arraySugestedMovies.count }
    
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
    
    // MARK: Netflix
    private var arrayNetflixMovies = [Netflix]() { didSet { delegate?.reloadData?() } }
    var numberOfNeflixMovies: Int { return arrayNetflixMovies.count }
    
    private var arrayStoriesPages = [StoriesPageItem]()
    
    // MARK: Variables
    private var isDataLoading = false
    
    // MARK: - Service requests -
    
    func loadData() {
        getNetflixMovies()
        getSugestedMovies()
        getMovies(genre: .popular)
        getMovies(genre: .topRated)
        getMovies(genre: .upcoming)
        getMovies(genre: .nowPlaying)
    }
    
    private func loadData(genre: GenreType?) {
        guard let genre = genre else {
            return
        }
        
        switch genre {
        case .netflix,
             .sugested:
            return
        case .popular:
            currentPopularMoviesPage += 1
        case .topRated:
            currentTopRatedMoviesPage += 1
        case .upcoming:
            currentUpcomingMoviesPage += 1
        case .nowPlaying:
            currentNowPlayingMoviesPage += 1
        }
        
        getMovies(genre: genre)
    }
    
    func getNetflixMovies() {
        guard let userPersonalityType = Singleton.shared.userPersonalityType, let genres = userPersonalityType.netflixGenres else {
            return
        }
        
        arrayNetflixMovies = [Netflix]()
        genres.forEach { [weak self] (genre) in
            self?.getNetflixMoviesGenres(id: genre)
        }
    }
    
    private func getNetflixMoviesGenres(id: Int?) {
        netflixServiceModel.getNetflixMovies(genre: id) { [weak self] (object) in
            guard let result = object as? [Netflix] else {
                return
            }
            let sortedArray = result.sorted(by: { (movie1, movie2) -> Bool in
                guard let rating1 = movie1.imdbRating, let rating2 = movie2.imdbRating else {
                    return true
                }
                return rating1 > rating2
            })
            self?.arrayNetflixMovies.append(contentsOf: sortedArray)
            self?.reloadData(at: GenreType.netflix.index)
        }
    }
    
    private func getSugestedMovies() {
        guard let userPersonalityType = Singleton.shared.userPersonalityType, let genres = userPersonalityType.genres else {
            return
        }
        
        arraySugestedMovies = [Movie]()
        genres.forEach { [weak self] (id) in
            self?.getMoviesFromGenre(id: id)
        }
    }
    
    private func getMoviesFromGenre(id: Int?) {
        guard let value = id else {
            return
        }
        
        let parameters: [String: Any] = [
            "id": value,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        SearchServiceModel().getMoviesFromGenre(urlParameters: parameters) { [weak self] (object) in
            guard let object = object as? SearchMoviesGenre, let results = object.results else {
                return
            }
            let result = self?.arraySugestedMovies.contains {
                let id = $0.id
                let map = results.map { return $0.id }
                return map.contains { return $0 == id }
            }
            guard let contains = result, !contains else {
                return
            }
            guard let array = self?.sortedByVoteAverage(array: results) else {
                return
            }
            self?.addMoviesToArray(array, genre: .sugested)
            self?.reloadData(at: GenreType.sugested.index)
        }
    }
    
    private func sortedByVoteAverage(array: [Movie]) -> [Movie] {
        let sortedArray = array.sorted(by: { (movie1, movie2) -> Bool in
            guard let voteAverage1 = movie1.voteAverage, let voteAverage2 = movie2.voteAverage else {
                return true
            }
            return voteAverage1 > voteAverage2
        })
        
        return sortedArray
    }
    
    private func getMovies(genre: GenreType) {
        guard let requestUrl = getRequestUrl(with: genre) else {
            return
        }
        
        var currentPage = getCurrentPage(at: genre)
        
        isDataLoading = true
        
        let parameters: [String: Any] = [
            "page": currentPage,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        serviceModel.getMovies(urlParameters: parameters, requestUrl: requestUrl) { [weak self] (object) in
            if let object = object as? MoviesList {
                do {
                    try self?.showError(with: object)
                } catch {
                    if let error = error as? Error {
                        self?.delegate?.showError?(message: error.message)
                    }
                    return
                }
                
                if let results = object.results {
                    self?.addMoviesToArray(results, genre: genre)
                    currentPage += 1
                }
            }
            
            self?.reloadData(at: genre.index)
        }
    }
    
    private func getRequestUrl(with genre: GenreType) -> RequestUrl? {
        switch genre {
        case .netflix,
             .sugested:
            return nil
        case .popular:
            return .popular
        case .topRated:
            return .topRated
        case .upcoming:
            return .upcoming
        case .nowPlaying:
            return .nowPlaying
        }
    }
    
    private func getCurrentPage(at genre: GenreType) -> Int {
        switch genre {
        case .netflix,
             .sugested:
            return 0
        case .popular:
            return currentPopularMoviesPage
        case .topRated:
            return currentTopRatedMoviesPage
        case .upcoming:
            return currentUpcomingMoviesPage
        case .nowPlaying:
            return currentNowPlayingMoviesPage
        }
    }
    
    private func addMoviesToArray(_ results: [Movie], genre: GenreType) {
        switch genre {
        case .netflix:
            break
        case .sugested:
            arraySugestedMovies.append(contentsOf: results)
        case .popular:
            arrayPopularMovies.append(contentsOf: results)
        case .topRated:
            arrayTopRatedMovies.append(contentsOf: results)
        case .upcoming:
            arrayUpcomingMovies.append(contentsOf: results)
        case .nowPlaying:
            arrayNowPlayingMovies.append(contentsOf: results)
        }
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
    
    // MARK: - Movie methods -
    
    func numberOfMovies(at section: Int) -> Int {
        guard let genre = GenreType.genre(at: section) else {
            return 0
        }
        switch genre {
        case .netflix:
            return numberOfNeflixMovies
        case .sugested:
            return numberOfSugestedMovies
        case .popular:
            return numberOfPopularMovies
        case .topRated:
            return numberOfTopRatedMovies
        case .upcoming:
            return numberOfUpcomingMovies
        case .nowPlaying:
            return numberOfNowPlayingMovies
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
        return URL(string: serviceModel.imageUrl(with: movie.posterPath))
    }
    
    func storyPreviewImagePathUrl(at index: Int) -> URL? {
        let movie = arrayNetflixMovies[index]
        return URL(string: netflixServiceModel.imageUrl(with: movie.id))
    }
    
    private func getMoviesArray(at section: Int) -> [Movie]? {
        guard let genre = GenreType.genre(at: section) else {
            return nil
        }
        switch genre {
        case .netflix:
            return nil
        case .sugested:
            return arraySugestedMovies
        case .popular:
            return arrayPopularMovies
        case .topRated:
            return arrayTopRatedMovies
        case .upcoming:
            return arrayUpcomingMovies
        case .nowPlaying:
            return arrayNowPlayingMovies
        }
    }
    
    func doServicePaginationIfNeeded(at section: Int, row: Int) {
        guard let results = getMoviesArray(at: section) else {
            return
        }
        
        if row == results.count-2 && !isDataLoading {
            loadData(genre: GenreType.genre(at: section))
        }
    }
    
    func loadVideos(at index: Int) {
        delegate?.openPreview(storiesViewModel: StoriesViewModel(arrayNetflixMovies, selectedIndex: index))
    }
    
    //MARK: Detail view model
    
    func movieDetailViewModel(at section: Int, row: Int) -> MovieDetailViewModel? {
        guard let movie = movie(at: section, row: row) else {
            return nil
        }
        return MovieDetailViewModel(movie)
    }
    
    func searchResultViewModel(with text: String?) -> SearchResultViewModel? {
        return SearchResultViewModel(searchText: text)
    }
}