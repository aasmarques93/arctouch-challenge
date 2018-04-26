//
//  SearchViewModel.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

protocol SearchViewModelDelegate: class {
    func reloadData()
    func reloadMoviesList()
    func showError(message: String?)
}

class SearchViewModel: ViewModel {
    // MARK: - Singleton -
    static let shared = SearchViewModel()
    
    // MARK: - Properties -
    
    var serviceModel = SearchServiceModel()
    
    // MARK: Delegate
    weak var delegate: SearchViewModelDelegate?
    
    //MARK: Genre
    var arrayGenres = [Genres]() { didSet { delegate?.reloadData() } }
    var numberOfGenres: Int { return arrayGenres.count }
    
    var selectedGenre: Genres?
    
    //MARK: Movie
    var arrayMovies = [Movie]() { didSet { delegate?.reloadMoviesList() } }
    var numberOfMovies: Int { return arrayMovies.count }
    
    var searchText: String?
    
    // MARK: - Service requests -
    
    func loadData() {
        loadingView.startInWindow()
        serviceModel.getGenres { (object) in
            self.loadingView.stop()
            if let object = object as? MoviesGenres {
                if let statusMessage = object.statusMessage, statusMessage != "" {
                    self.delegate?.showError(message: statusMessage)
                    return
                }
                
                if let results = object.genres {
                    self.arrayGenres = results
                }
            }
        }
    }
    
    func loadMoviesForSelectedGenre() {
        if let genre = selectedGenre, let value = genre.id {
            let parameters = ["id": value]
        
            loadingView.startInWindow()
            serviceModel.getMoviesFromGenre(urlParameters: parameters) { (object) in
                self.loadingView.stop()
                if let object = object as? SearchMoviesGenre {
                    if let statusMessage = object.statusMessage, statusMessage != "" {
                        self.delegate?.showError(message: statusMessage)
                        return
                    }
                    if let results = object.results {
                        self.arrayMovies = results
                    }
                }
            }
        }
    }
    
    func doSearchMovies(with text: String?) {
        if let value = text {
            searchText = value
            
            let parameters = ["query": value.replacingOccurrences(of: " ", with: "%20")]
            
            loadingView.startInWindow()
            serviceModel.doSearchMovies(urlParameters: parameters) { (object) in
                self.loadingView.stop()
                if let object = object as? SearchMovie {
                    if let statusMessage = object.statusMessage, statusMessage != "" {
                        self.delegate?.showError(message: statusMessage)
                        return
                    }
                    if let results = object.results {
                        self.selectedGenre = nil
                        self.arrayMovies = results
                    }
                }
            }
        }
    }
    
    // MARK: - View Model -
    
    func titleDescription(at indexPath: IndexPath? = nil) -> String? {
        if let indexPath = indexPath {
            return arrayGenres[indexPath.row].name
        }
        if let selectedGenre = selectedGenre {
            return selectedGenre.name
        }
        return searchText
    }
    
    func selectGenre(at indexPath: IndexPath) {
        if indexPath.row < arrayGenres.count { selectedGenre = arrayGenres[indexPath.row] }
    }
    
    func imageData(at indexPath: IndexPath, handlerData: @escaping HandlerObject) {
        let movie = arrayMovies[indexPath.row]
        
        if let data = movie.imageData {
            handlerData(data)
            return
        }
        
        handlerData(nil)
        serviceModel.loadImage(path: movie.posterPath, handlerData: { (data) in
            self.arrayMovies[indexPath.row].imageData = data as? Data
            handlerData(data)
        })
    }
    
    func movieName(at indexPath: IndexPath) -> String? {
        return arrayMovies[indexPath.row].originalTitle
    }
    
    func movieDetailViewModel(at indexPath: IndexPath) -> MovieDetailViewModel? {
        let movie = arrayMovies[indexPath.row]
        return MovieDetailViewModel(movie)
    }
}
