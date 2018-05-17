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
    var isMultipleSearch: Bool {
        return requestUrl == .multiSearch
    }
    
    private var requestUrl: RequestUrl = .searchMovie
    
    // MARK: - Life cycle -
    
    init(selectedGenre: Genres? = nil, searchText: String? = nil, requestUrl: RequestUrl = .searchMovie) {
        self.selectedGenre = selectedGenre
        self.searchText = searchText
        self.requestUrl = requestUrl
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        if let searchText = searchText, !searchText.isEmptyOrWhitespace {
            doSearch()
            return
        }
        
        getMoviesFromGenre()
    }
    
    private func doSearch() {
        guard let value = searchText else {
            return
        }
        
        let parameters: [String: Any] = [
            "query": value.replacingOccurrences(of: " ", with: "%20"),
            "page": currentPage,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        
        isDataLoading = true
        
        serviceModel.doSearch(requestUrl: requestUrl, urlParameters: parameters) { [weak self] (object) in
            self?.isDataLoading = false
            
            guard let object = object as? MultiSearch, let results = object.results else {
                return
            }
            
            self?.totalPages = object.totalPages
            self?.arraySearch.append(contentsOf: results)
            
            if let requestUrl = self?.requestUrl, requestUrl == .multiSearch {
                self?.doFilter(index: self?.selectedType.rawValue)
            } else {
                if let results = self?.arraySearch { self?.arraySearchFiltered = results }
            }
        }
    }
    
    private func getMoviesFromGenre() {
        guard let genre = selectedGenre, let value = genre.id else {
            return
        }
        
        let parameters: [String: Any] = [
            "id": value,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        
        isDataLoading = true
        
        serviceModel.getMoviesFromGenre(urlParameters: parameters) { [weak self] (object) in
            self?.isDataLoading = false
            
            guard let object = object as? SearchMoviesGenre else {
                return
            }
            
            do {
                try self?.showError(with: object)
            } catch {
                guard let error = error as? Error else {
                    return
                }
                self?.delegate?.showError?(message: error.message)
                return
            }
            
            guard let results = object.results else {
                return
            }
            
            self?.arraySearch = [SearchResult]()
            
            for result in results {
                self?.arraySearch.append(SearchResult(object: result.dictionaryRepresentation()))
            }
            
            if let results = self?.arraySearch { self?.arraySearchFiltered = results }
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
    
    func doFilter(index: Int?) {
        guard let index = index, let type = SearchResultFilterType(rawValue: index) else {
            return
        }

        selectedType = type
        arraySearchFiltered = arraySearch.filter { $0.mediaType == type.description }
    }
    
    // MARK: - View Model -
    
    var titleDescription: String? {
        return selectedGenre?.name ?? searchText
    }
    
    func posterImageUrl(at indexPath: IndexPath) -> URL? {
        let result = arraySearchFiltered[indexPath.row]
        
        var path: String?
        
        if selectedType == .person {
            path = result.profilePath
        } else {
            path = result.posterPath
        }
        
        return URL(string: serviceModel.imageUrl(with: path))
    }
    
    func backgroundImageUrl(at indexPath: IndexPath) -> URL? {
        let result = arraySearchFiltered[indexPath.row]
        return URL(string: serviceModel.imageUrl(with: result.backdropPath))
    }
    
    func movieName(at indexPath: IndexPath) -> String? {
        let result = arraySearchFiltered[indexPath.row]
        return result.name ?? result.title ?? result.originalName
    }
    
    func movieOverview(at indexPath: IndexPath) -> String? {
        return arraySearchFiltered[indexPath.row].overview
    }
    
    func movieDetailViewModel(at indexPath: IndexPath) -> MovieDetailViewModel? {
        let result = arraySearchFiltered[indexPath.row]
        return MovieDetailViewModel(Movie(object: result.dictionaryRepresentation()))
    }
}
