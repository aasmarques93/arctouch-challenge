//
//  SearchResultViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

protocol SearchResultViewModelDelegate: class {
    func reloadData()
}

class SearchResultViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Service Model
    let serviceModel = SearchServiceModel()
    
    // MARK: Delegate
    weak var delegate: SearchViewModelDelegate?
    
    // MARK: Genre
    private var selectedGenre: Genres?
    
    // MARK: Movie
    private var arrayMovies = [Movie]() { didSet { delegate?.reloadData() } }
    var numberOfMovies: Int { return arrayMovies.count }
    
    // MARK: Variables
    private var isDataLoading = false
    private var searchText: String?
    private var currentPage: Int = 1
    
    // MARK: - Life cycle -
    
    init(selectedGenre: Genres? = nil, searchText: String? = nil) {
        super.init()
        self.selectedGenre = selectedGenre
        self.searchText = searchText
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        if let searchText = searchText, !searchText.isEmptyOrWhitespace {
            doSearchMovies()
            return
        }
        
        if let genre = selectedGenre, let value = genre.id {
            let parameters = ["id": value]
            
            loadingView.startInWindow()
            isDataLoading = true
            
            serviceModel.getMoviesFromGenre(urlParameters: parameters) { (object) in
                self.loadingView.stop()
                self.isDataLoading = false
                
                if let object = object as? SearchMoviesGenre, let results = object.results {
                    self.arrayMovies.append(contentsOf: results)
                }
            }
        }
    }
    
    func doServicePaginationIfNeeded(at indexPath: IndexPath) {
        if indexPath.row == arrayMovies.count-2 && !isDataLoading {
            currentPage += 1
            loadData()
        }
    }
    
    func doSearchMovies() {
        if let value = searchText {
            currentPage = 1
            arrayMovies = [Movie]()
            
            let parameters: [String:Any] = ["query": value.replacingOccurrences(of: " ", with: "%20"), "page": currentPage]
            
            loadingView.startInWindow()
            serviceModel.doSearchMovies(urlParameters: parameters) { (object) in
                self.loadingView.stop()
                if let object = object as? SearchMovie, let results = object.results {
                    self.arrayMovies = results
                }
            }
        }
    }
    
    // MARK: - View Model -
    
    var titleDescription: String? {
        return selectedGenre?.name ?? searchText
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
