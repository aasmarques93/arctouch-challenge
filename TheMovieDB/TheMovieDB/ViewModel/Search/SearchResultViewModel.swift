//
//  SearchResultViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

enum SearchResultFilterType: Int {
    case movies
    case tvShow
    case person
    
    var description: String {
        switch self {
            case .movies: return "movie"
            case .tvShow: return "tv"
            case .person: return "person"
        }
    }
}

class SearchResultViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Service Model
    let serviceModel = SearchServiceModel()
    
    // MARK: Delegate
    weak var delegate: ViewModelDelegate?
    
    // MARK: Genre
    private var selectedGenre: Genres?
    
    // MARK: Search
    private var arraySearch = [SearchResult]()
    private var arraySearchFiltered = [SearchResult]() { didSet { if let method = delegate?.reloadData { method() } } }
    var numberOfSearchResults: Int { return arraySearchFiltered.count }
    
    // MARK: Variables
    private var isDataLoading = false
    private var searchText: String?
    private var currentPage: Int = 1
    private var totalPages: Int?
    private var selectedType: SearchResultFilterType = .movies
    var isMultipleSearch: Bool = false
    
    // MARK: - Life cycle -
    
    init(selectedGenre: Genres? = nil, searchText: String? = nil, isMultipleSearch: Bool = false) {
        super.init()
        self.selectedGenre = selectedGenre
        self.searchText = searchText
        self.isMultipleSearch = isMultipleSearch
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        if let searchText = searchText, !searchText.isEmptyOrWhitespace {
            doSearch()
            return
        }
        
        if let genre = selectedGenre, let value = genre.id {
            let parameters = ["id": value]
            
            isDataLoading = true
            
            serviceModel.getMoviesFromGenre(urlParameters: parameters) { (object) in
                self.isDataLoading = false
                
                if let object = object as? SearchMoviesGenre {
                    if self.showError(with: object) {
                        if let method = self.delegate?.showError { method(object.statusMessage) }
                        return
                    }
                    
                    if let results = object.results {
                        self.arraySearch = [SearchResult]()
                        for result in results {
                            self.arraySearch.append(SearchResult(object: result.dictionaryRepresentation()))
                            self.arraySearchFiltered = self.arraySearch
                        }
                    }
                }
            }
        }
    }
    
    func doServicePaginationIfNeeded(at indexPath: IndexPath) {
        if indexPath.row == arraySearchFiltered.count-2 && !isDataLoading {
            currentPage += 1
            
            if let totalPages = totalPages, currentPage < totalPages {
                loadData()
            }
        }
    }
    
    private func doSearch() {
        if let value = searchText {
            let parameters: [String:Any] = ["query": value.replacingOccurrences(of: " ", with: "%20"), "page": currentPage]
            
            serviceModel.doSearch(urlParameters: parameters, isMultipleSearch: isMultipleSearch) { (object) in
                if let object = object as? MultiSearch, let results = object.results {
                    self.totalPages = object.totalPages
                    self.arraySearch.append(contentsOf: results)
                    
                    if self.isMultipleSearch {
                        self.doFilter(index: self.selectedType.rawValue)
                    } else {
                        self.arraySearchFiltered = self.arraySearch
                    }
                }
            }
        }
    }
    
    func doFilter(index: Int) {
        if let type = SearchResultFilterType(rawValue: index) {
            selectedType = type
            arraySearchFiltered = arraySearch.filter { return $0.mediaType == type.description }
        }
    }
    
    // MARK: - View Model -
    
    var titleDescription: String? {
        return selectedGenre?.name ?? searchText
    }
    
    func posterImageData(at indexPath: IndexPath, handlerData: @escaping HandlerObject) {
        let result = arraySearchFiltered[indexPath.row]
        
        if let data = result.imageData {
            handlerData(data)
            return
        }
        
        var path: String?
        
        if selectedType == .person {
            path = result.profilePath
        } else {
            path = result.posterPath
        }

        if path == nil {
            handlerData(nil)
            return
        }
        
        imageData(path: path) { (data) in
            result.imageData = data as? Data
            handlerData(data)
        }
    }
    
    func backgroundImageData(at indexPath: IndexPath, handlerData: @escaping HandlerObject) {
        let result = arraySearchFiltered[indexPath.row]
        imageData(path: result.backdropPath, handlerData: handlerData)
    }
    
    private func imageData(path: String?, handlerData: @escaping HandlerObject) {
        serviceModel.loadImage(path: path ?? "", handlerData: handlerData)
    }
    
    func movieName(at indexPath: IndexPath) -> String? {
        let result = arraySearchFiltered[indexPath.row]
        return result.name ?? result.originalTitle ?? result.originalName
    }
    
    func movieDetailViewModel(at indexPath: IndexPath) -> MovieDetailViewModel? {
        let result = arraySearchFiltered[indexPath.row]
        return MovieDetailViewModel(Movie(object: result.dictionaryRepresentation()))
    }
}
