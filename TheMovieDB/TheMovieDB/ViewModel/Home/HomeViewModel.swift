//
//  HomeViewModel.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

protocol HomeViewModelDelegate: class {
    func reloadData(at index: Int)
    func showError(message: String?)
}

enum Genre: String {
    case nowPlaying = "Now Playing"
    case upcoming = "Upcoming"
    case topRated = "Top Rated"
    case popular = "Popular"
    
    var index: Int {
        switch self {
            case .nowPlaying: return 0
            case .upcoming: return 1
            case .topRated: return 2
            case .popular: return 3
        }
    }
    
    static func genre(at index: Int) -> Genre? {
        switch index {
            case 0: return Genre.nowPlaying
            case 1: return Genre.upcoming
            case 2: return Genre.topRated
            case 3: return Genre.popular
            default: return nil
        }
    }
}

class HomeViewModel: ViewModel {
    // MARK: - Singleton -
    static let shared = HomeViewModel()
    
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: HomeViewModelDelegate?
    
    let serviceModel = HomeServiceModel.shared
    
    // MARK: Genres
    private var arrayGenres: [Genre] = [.nowPlaying, .upcoming, .topRated, .popular]
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
    
    private var isDataLoading = false
    
    // MARK: - Service requests -
    
    func loadData(genre: Genre? = nil) {
        guard let genre = genre else {
            getMovies(genre: .nowPlaying)
            getMovies(genre: .upcoming)
            getMovies(genre: .topRated)
            getMovies(genre: .popular)
            return
        }
        
        
        switch genre {
            case .nowPlaying:
                currentNowPlayingMoviesPage += 1
                getMovies(genre: .nowPlaying)
            case .upcoming:
                currentUpcomingMoviesPage += 1
                getMovies(genre: .upcoming)
            case .topRated:
                currentTopRatedListPage += 1
                getMovies(genre: .topRated)
            case .popular:
                currentPopularListPage += 1
                getMovies(genre: .popular)
        }
    }
    
    private func getMovies(genre: Genre) {
        var requestUrl: RequestUrl?
        var currentPage = 1
        
        switch genre {
            case .nowPlaying:
                requestUrl = .nowPlaying
                currentPage = currentNowPlayingMoviesPage
            case .upcoming:
                requestUrl = .upcoming
                currentPage = currentUpcomingMoviesPage
            case .topRated:
                requestUrl = .topRated
                currentPage = currentTopRatedListPage
            case .popular:
                requestUrl = .popular
                currentPage = currentPopularListPage
        }
        
        if let requestUrl = requestUrl {
            isDataLoading = true
            
            let parameters = ["page": currentPage]
            serviceModel.getMovies(urlParameters: parameters, requestUrl: requestUrl) { (object) in
                if let object = object as? MoviesList {
                    if self.showError(with: object) { return }
                    
                    if let results = object.results {
                        self.addMoviesToList(results, genre: genre)
                        currentPage += 1
                    }
                }
                
                self.reloadData(at: genre.index)
            }
        }
    }
    
    private func addMoviesToList(_ results: [Movie], genre: Genre) {
        switch genre {
            case .nowPlaying: nowPlayingMoviesList.append(contentsOf: results)
            case .upcoming: upcomingMoviesList.append(contentsOf: results)
            case .topRated: topRatedList.append(contentsOf: results)
            case .popular: popularList.append(contentsOf: results)
        }
    }
    
    private func showError(with object: Model) -> Bool {
        if let statusMessage = object.statusMessage, statusMessage != "" {
            self.delegate?.showError(message: statusMessage)
            return true
        }
        return false
    }
    
    private func reloadData(at index: Int) {
        delegate?.reloadData(at: index)
        isDataLoading = false
    }
    
    // MARK: - Genre methods -
    
    func genreTitle(at section: Int) -> String {
        if let genre = Genre.genre(at: section) {
            return "  \(genre.rawValue)"
        }
        return ""
    }
    
    // MARK: - Movie methods -
    
    func numberOfMovies(at section: Int) -> Int {
        if let genre = Genre.genre(at: section) {
            switch genre {
                case .nowPlaying: return numberOfNowPlayingMovies
                case .upcoming: return numberOfUpcomingMovies
                case .topRated: return numberOfTopRatedList
                case .popular: return numberOfPopularList
            }
        }
        return 0
    }
    
    func isMoviesEmpty(at indexPath: IndexPath) -> Bool {
        return numberOfMovies(at: indexPath.section) == 0
    }
    
    func imagePathUrl(at section: Int, row: Int) -> URL? {
        if let results = getMoviesList(at: section) {
            let movie = results[row]
            return URL(string: serviceModel.imageUrl(with: movie.posterPath))
        }
        return nil
    }
    
    private func getMoviesList(at section: Int) -> [Movie]? {
        if let genre = Genre.genre(at: section) {
            switch genre {
                case .nowPlaying: return nowPlayingMoviesList
                case .upcoming: return upcomingMoviesList
                case .topRated: return topRatedList
                case .popular: return popularList
            }
        }
        return nil
    }
    
    func doServicePaginationIfNeeded(at section: Int, row: Int) {
        if let results = getMoviesList(at: section) {
            if row == results.count-2 && !isDataLoading {
                loadData(genre: Genre.genre(at: section))
            }
        }
    }
    
    //MARK: Detail view model
    
    func movieDetailViewModel(at section: Int, row: Int) -> MovieDetailViewModel? {
        if let results = getMoviesList(at: section) {
            let movie = results[row]
            return MovieDetailViewModel(movie)
        }
        return nil
    }
}
