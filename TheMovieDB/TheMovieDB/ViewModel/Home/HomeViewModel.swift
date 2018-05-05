//
//  HomeViewModel.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

protocol HomeViewModelDelegate: ViewModelDelegate {
    func reloadData(at index: Int)
    func didFinishSearch()
}

enum GenreType: String {
    case nowPlaying = "Now Playing"
    case topRated = "Top Rated"
    case upcoming = "Upcoming"
    case popular = "Popular"
    
    var index: Int {
        switch self {
            case .popular: return 0
            case .topRated: return 1
            case .upcoming: return 2
            case .nowPlaying: return 3
        }
    }
    
    static func genre(at index: Int) -> GenreType? {
        switch index {
            case 0: return GenreType.popular
            case 1: return GenreType.topRated
            case 2: return GenreType.upcoming
            case 3: return GenreType.nowPlaying
            default: return nil
        }
    }
}

class HomeViewModel: ViewModel {
    // MARK: - Singleton -
    static let shared = HomeViewModel()
    
    // MARK: - Properties -
    
    // MARK: Delegate
    var delegate: HomeViewModelDelegate?
    
    // MARK: Service Model
    let serviceModel = HomeServiceModel()
    
    // MARK: Genres
    private var arrayGenres: [GenreType] = [.popular, .topRated, .upcoming, .nowPlaying]
    var numberOfGenres: Int { return arrayGenres.count }
    
    // MARK: Now Playing
    private var nowPlayingMoviesList = [Movie]()
    var numberOfNowPlayingMovies: Int { return nowPlayingMoviesList.count }
    private var currentNowPlayingMoviesPage: Int = 1
    
    // MARK: Upcoming movies
    private var upcomingMoviesList = [Movie]()
    var numberOfUpcomingMovies: Int { return upcomingMoviesList.count }
    private var currentUpcomingMoviesPage: Int = 1
    
    // MARK: Top rated
    private var topRatedList = [Movie]()
    var numberOfTopRatedList: Int { return topRatedList.count }
    private var currentTopRatedListPage: Int = 1
    
    // MARK: Popular
    private var popularList = [Movie]()
    var numberOfPopularList: Int { return popularList.count }
    private var currentPopularListPage: Int = 1
    
    // MARK: Variables
    private var isDataLoading = false
    
    // MARK: - Service requests -
    
    func loadData() {
        getMovies(genre: .popular)
        getMovies(genre: .topRated)
        getMovies(genre: .upcoming)
        getMovies(genre: .nowPlaying)
    }
    
    private func loadData(genre: GenreType?) {
        guard let genre = genre else { return }
        
        switch genre {
            case .popular:
                currentPopularListPage += 1
                getMovies(genre: .popular)
            case .topRated:
                currentTopRatedListPage += 1
                getMovies(genre: .topRated)
            case .upcoming:
                currentUpcomingMoviesPage += 1
                getMovies(genre: .upcoming)
            case .nowPlaying:
                currentNowPlayingMoviesPage += 1
                getMovies(genre: .nowPlaying)
        }
    }
    
    private func getMovies(genre: GenreType) {
        let requestUrl = getRequestUrl(with: genre)
        var currentPage = getCurrentPage(at: genre)
    
        isDataLoading = true
        
        let parameters = ["page": currentPage]
        serviceModel.getMovies(urlParameters: parameters, requestUrl: requestUrl) { (object) in
            if let object = object as? MoviesList {
                if self.showError(with: object) {
                    self.delegate?.showError?(message: object.statusMessage)
                    return
                }
                
                if let results = object.results {
                    self.addMoviesToList(results, genre: genre)
                    currentPage += 1
                }
            }
            
            self.reloadData(at: genre.index)
        }
    }
    
    private func getRequestUrl(with genre: GenreType) -> RequestUrl {
        switch genre {
            case .popular: return .popular
            case .topRated: return .topRated
            case .upcoming: return .upcoming
            case .nowPlaying: return .nowPlaying
        }
    }
    
    private func getCurrentPage(at genre: GenreType) -> Int {
        switch genre {
            case .popular: return currentPopularListPage
            case .topRated: return currentTopRatedListPage
            case .upcoming: return currentUpcomingMoviesPage
            case .nowPlaying: return currentNowPlayingMoviesPage
        }
    }
    
    private func addMoviesToList(_ results: [Movie], genre: GenreType) {
        switch genre {
            case .popular: popularList.append(contentsOf: results)
            case .topRated: topRatedList.append(contentsOf: results)
            case .upcoming: upcomingMoviesList.append(contentsOf: results)
            case .nowPlaying: nowPlayingMoviesList.append(contentsOf: results)
        }
    }
    
    private func reloadData(at index: Int) {
        delegate?.reloadData(at: index)
        isDataLoading = false
    }
    
    // MARK: - Genre methods -
    
    func genreTitle(at section: Int) -> String {
        if let genre = GenreType.genre(at: section) {
            return "  \(genre.rawValue)"
        }
        return ""
    }
    
    // MARK: - Movie methods -
    
    func numberOfMovies(at section: Int) -> Int {
        if let genre = GenreType.genre(at: section) {
            switch genre {
                case .popular: return numberOfPopularList
                case .topRated: return numberOfTopRatedList
                case .upcoming: return numberOfUpcomingMovies
                case .nowPlaying: return numberOfNowPlayingMovies
            }
        }
        return 0
    }
    
    func isMoviesEmpty(at indexPath: IndexPath) -> Bool {
        return numberOfMovies(at: indexPath.section) == 0
    }
    
    func movie(at section: Int, row: Int) -> Movie? {
        if let results = getMoviesList(at: section), row < results.count { return results[row] }
        return nil
    }
    
    func imagePathUrl(at section: Int, row: Int) -> URL? {
        if let movie = movie(at: section, row: row) {
            return URL(string: serviceModel.imageUrl(with: movie.posterPath))
        }
        return nil
    }
    
    private func getMoviesList(at section: Int) -> [Movie]? {
        if let genre = GenreType.genre(at: section) {
            switch genre {
                case .popular: return popularList
                case .topRated: return topRatedList
                case .upcoming: return upcomingMoviesList
                case .nowPlaying: return nowPlayingMoviesList
            }
        }
        return nil
    }
    
    func doServicePaginationIfNeeded(at section: Int, row: Int) {
        if let results = getMoviesList(at: section) {
            if row == results.count-2 && !isDataLoading {
                loadData(genre: GenreType.genre(at: section))
            }
        }
    }
    
    //MARK: Detail view model
    
    func movieDetailViewModel(at section: Int, row: Int) -> MovieDetailViewModel? {
        if let movie = movie(at: section, row: row) {
            return MovieDetailViewModel(movie)
        }
        return nil
    }
    
    func searchResultViewModel(with text: String?) -> SearchResultViewModel? {
        return SearchResultViewModel(searchText: text)
    }
}
