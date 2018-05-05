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
        case .movies:
            return "movie"
        case .tvShow:
            return "tv"
        case .person:
            return "person"
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
    private var arraySearchFiltered = [SearchResult]() { didSet { delegate?.reloadData?() } }
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
        
        guard let genre = selectedGenre, let value = genre.id else {
            return
        }

        let parameters = ["id": value]

        isDataLoading = true

        serviceModel.getMoviesFromGenre(urlParameters: parameters) { [weak self] (object) in
            guard let strongSelf = self else {
                return
            }

            strongSelf.isDataLoading = false

            guard let object = object as? SearchMoviesGenre else {
                return
            }

            do {
                try strongSelf.showError(with: object)
            } catch {
                guard let error = error as? Error else {
                    return
                }
                strongSelf.delegate?.showError?(message: error.message)
                return
            }

            guard let results = object.results else {
                return
            }

            strongSelf.arraySearch = [SearchResult]()
            for result in results {
                strongSelf.arraySearch.append(SearchResult(object: result.dictionaryRepresentation()))
                strongSelf.arraySearchFiltered = strongSelf.arraySearch
            }
        }
    }
    
    func doServicePaginationIfNeeded(at indexPath: IndexPath) {
        if indexPath.row == arraySearchFiltered.count-2 && !isDataLoading {
            currentPage += 1
            
            guard let totalPages = totalPages, currentPage < totalPages else {
                return
            }

            loadData()
        }
    }
    
    private func doSearch() {
        guard let value = searchText else {
            return
        }

        let parameters: [String:Any] = ["query": value.replacingOccurrences(of: " ", with: "%20"), "page": currentPage]

        serviceModel.doSearch(urlParameters: parameters, isMultipleSearch: isMultipleSearch) { [weak self] (object) in
            guard let strongSelf = self else {
                return
            }
            guard let object = object as? MultiSearch, let results = object.results else {
                return
            }

            strongSelf.totalPages = object.totalPages
            strongSelf.arraySearch.append(contentsOf: results)

            if strongSelf.isMultipleSearch {
                strongSelf.doFilter(index: strongSelf.selectedType.rawValue)
            } else {
                strongSelf.arraySearchFiltered = strongSelf.arraySearch
            }
        }
    }
    
    func doFilter(index: Int) {
        guard let type = SearchResultFilterType(rawValue: index) else {
            return
        }

        selectedType = type
        arraySearchFiltered = arraySearch.filter { return $0.mediaType == type.description }
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
        
        loadImageData(at: path) { (data) in
            if indexPath.row < self.arraySearchFiltered.count {
                self.arraySearchFiltered[indexPath.row].imageData = data as? Data
            }
            handlerData(data)
        }
    }
    
    func backgroundImageData(at indexPath: IndexPath, handlerData: @escaping HandlerObject) {
        let result = arraySearchFiltered[indexPath.row]
        loadImageData(at: result.backdropPath, handlerData: handlerData)
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
