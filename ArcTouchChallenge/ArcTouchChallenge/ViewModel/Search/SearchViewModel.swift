//
//  SearchViewModel.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

protocol SearchViewModelDelegate: class {
    func reloadData()
    func reloadMoviesList()
}

class SearchViewModel: ViewModel {
    static let shared = SearchViewModel()
    
    weak var delegate: SearchViewModelDelegate?
    
    var arrayGenres = [Genres]() { didSet { delegate?.reloadData() } }
    var numberOfGenres: Int { return arrayGenres.count }
    
    var arrayMovies = [Movie]() { didSet { delegate?.reloadMoviesList() } }
    var numberOfMovies: Int { return arrayMovies.count }
    
    var selectedGenre: Genres?
    
    func loadData() {
        loadingView.startInWindow()
        SearchServiceModel.shared.getGenres { (object) in
            self.loadingView.stop()
            if let object = object as? MoviesGenres, let results = object.genres {
                self.arrayGenres = results
            }
        }
    }
    
    func loadMoviesForSelectedGenre() {
        if let genre = selectedGenre, let value = genre.id {
            let parameters = ["id": value]
        
            loadingView.startInWindow()
            SearchServiceModel.shared.getMoviesFromGenre(urlParameters: parameters) { (object) in
                self.loadingView.stop()
                if let object = object as? SearchMoviesGenre, let results = object.results {
                    self.arrayMovies = results
                }
            }
        }
    }
    
    func doSearchMovies(with text: String?) {
        if let value = text {
            let parameters = ["query": value.replacingOccurrences(of: " ", with: "%20")]
            
            loadingView.startInWindow()
            SearchServiceModel.shared.doSearchMovies(urlParameters: parameters) { (object) in
                self.loadingView.stop()
                if let object = object as? SearchMovie, let results = object.results {
                    self.arrayMovies = results
                }
            }
        }
    }
    
    func genreDescription(at indexPath: IndexPath? = nil) -> String? {
        if let indexPath = indexPath {
            return arrayGenres[indexPath.row].name
        }
        return selectedGenre?.name
    }
    
    func selectGenre(at indexPath: IndexPath) {
        selectedGenre = arrayGenres[indexPath.row]
    }
    
    func imageData(at indexPath: IndexPath, handlerData: @escaping HandlerObject) {
        let movie = arrayMovies[indexPath.row]
        
        if let data = movie.imageData {
            handlerData(data)
            return
        }
        
        handlerData(nil)
        HomeServiceModel.shared.loadImage(path: movie.posterPath, handlerData: { (data) in
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
