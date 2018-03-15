//
//  HomeViewModel.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

protocol HomeViewModelDelegate: class {
    func reloadData()
    func showError(message: String?)
}

enum Genre: String {
    case upcoming = "Upcoming"
    case topRated = "Top Rated"
    case popular = "Popular"
    
    static func genre(at index: Int) -> Genre? {
        switch index {
            case 0: return Genre.upcoming
            case 1: return Genre.topRated
            case 2: return Genre.popular
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
    
    // MARK: Genres
    var arrayGenres: [Genre] = [.upcoming, .topRated, .popular]
    var numberOfGenres: Int { return arrayGenres.count }
    
    // MARK: Upcoming movies
    var upcomingMoviesList = [Movie]()
    var numberOfUpcomingMovies: Int { return upcomingMoviesList.count }
    var currentUpcomingMoviesPage: Int = 1
    
    // MARK: Top rated
    var topRatedList = [Movie]()
    var numberOfTopRatedList: Int { return topRatedList.count }
    var currentTopRatedListPage: Int = 1
    
    // MARK: Popular
    var popularList = [Movie]()
    var numberOfPopularList: Int { return popularList.count }
    var currentPopularListPage: Int = 1
    
    var isDataLoading = false
    
    // MARK: - Service requests -
    
    func loadData(genre: Genre? = nil) {
        guard let genre = genre else {
            getUpcomingMovies()
            getTopRated()
            getPopularList()
            return
        }
        
        switch genre {
            case .upcoming:
                currentUpcomingMoviesPage += 1
                getUpcomingMovies()
            case .topRated:
                currentTopRatedListPage += 1
                getTopRated()
            case .popular:
                currentPopularListPage += 1
                getPopularList()
        }
    }
    
    func getUpcomingMovies() {
        isDataLoading = true
        
        let parameters = ["page": currentUpcomingMoviesPage]
        HomeServiceModel.shared.getUpcomingMovies(urlParameters: parameters) { (object) in            
            if let object = object as? UpcomingMoviesList {
                if let statusMessage = object.statusMessage, statusMessage != "" {
                    self.delegate?.showError(message: statusMessage)
                    return
                }
                if let results = object.results {
                    self.upcomingMoviesList.append(contentsOf: results)
                }
            }
            
            self.delegate?.reloadData()
            self.isDataLoading = false
        }
    }
    
    func getTopRated() {
        isDataLoading = true
        
        let parameters = ["page": currentTopRatedListPage]
        HomeServiceModel.shared.getTopRated(urlParameters: parameters) { (object) in
            if let object = object as? TopRatedList {
                if let statusMessage = object.statusMessage, statusMessage != "" {
                    self.delegate?.showError(message: statusMessage)
                    return
                }
            
                if let results = object.results {
                    self.topRatedList.append(contentsOf: results)
                }
            }
            self.delegate?.reloadData()
            self.isDataLoading = false
        }
    }
    
    func getPopularList() {
        isDataLoading = true
        
        let parameters = ["page": currentPopularListPage]
        HomeServiceModel.shared.getPopularList(urlParameters: parameters) { (object) in
            if let object = object as? PopularList {
                if let statusMessage = object.statusMessage, statusMessage != "" {
                    self.delegate?.showError(message: statusMessage)
                    return
                }
                
                if let results = object.results {
                    self.popularList.append(contentsOf: results)
                }
            }
            self.delegate?.reloadData()
            self.isDataLoading = false
        }
    }
    
    // MARK: - Genre methods -
    
    func genreTitle(at section: Int) -> String {
        if let genre = Genre.genre(at: section) { return "  \(genre.rawValue)" }
        return ""
    }
    
    // MARK: - Movie methods -
    
    func numberOfMovies(at section: Int) -> Int {
        if let genre = Genre.genre(at: section) {
            switch genre {
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
    
    func imageData(at section: Int, row: Int, handlerData: @escaping HandlerObject) {
        if let results = getMoviesList(at: section) {
            let movie = results[row]
            
            if let data = movie.imageData {
                handlerData(data)
                return
            }
            
            handlerData(nil)
            
            HomeServiceModel.shared.loadImage(path: movie.posterPath, handlerData: { (data) in
                results[row].imageData = data as? Data
                handlerData(data)
            })
        }
    }
    
    func getMoviesList(at section: Int) -> [Movie]? {
        if let genre = Genre.genre(at: section) {
            switch genre {
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
