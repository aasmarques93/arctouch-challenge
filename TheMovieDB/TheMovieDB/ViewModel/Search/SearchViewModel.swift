//
//  SearchViewModel.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

protocol SearchViewModelDelegate: class {
    func reloadData()
    func reloadMoviesList()
    func showError(message: String?)
}

class SearchViewModel: ViewModel {
    // MARK: - Singleton -
    static let shared = SearchViewModel()
    
    // MARK: - Properties -
    
    // MARK: Service Model
    let serviceModel = SearchServiceModel()
    
    // MARK: Delegate
    weak var delegate: SearchViewModelDelegate?
    
    // MARK: Genre
    private var arrayGenres = [Genres]() { didSet { delegate?.reloadData() } }
    var numberOfGenres: Int { return arrayGenres.count }
    
    private var selectedGenre: Genres?
    
    // MARK: Movie
    private var arrayMovies = [Movie]() { didSet { delegate?.reloadMoviesList() } }
    var numberOfMovies: Int { return arrayMovies.count }
    
    // MARK: Variables
    private var searchText: String?
    
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
    
    func doSearchMovies(with text: String?, handlerObject: HandlerObject? = nil) {
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
                        if let handlerObject = handlerObject { handlerObject(object) }
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
    
    func posterImageData(at indexPath: IndexPath, handlerData: @escaping HandlerObject) {
        let movie = arrayMovies[indexPath.row]
        
        if let data = movie.imageData {
            handlerData(data)
            return
        }
        
        imageData(path: movie.posterPath) { (data) in
            self.arrayMovies[indexPath.row].imageData = data as? Data
            handlerData(data)
        }
    }
    
    func backgroundImageData(at indexPath: IndexPath, handlerData: @escaping HandlerObject) {
        let movie = arrayMovies[indexPath.row]
        imageData(path: movie.backdropPath, handlerData: handlerData)
    }
    
    private func imageData(path: String?, handlerData: @escaping HandlerObject) {
        serviceModel.loadImage(path: path ?? "", handlerData: handlerData)
    }
    
    func movieName(at indexPath: IndexPath) -> String? {
        return arrayMovies[indexPath.row].originalTitle
    }
    
    func movieDetailViewModel(at indexPath: IndexPath) -> MovieDetailViewModel? {
        let movie = arrayMovies[indexPath.row]
        return MovieDetailViewModel(movie)
    }
}
