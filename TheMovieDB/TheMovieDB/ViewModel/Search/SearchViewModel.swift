//
//  SearchViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

class SearchViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Service Model
    let serviceModel = SearchServiceModel()
    
    // MARK: Delegate
    weak var delegate: ViewModelDelegate?
    
    // MARK: Genre
    
    enum GenreType: Int {
        case movies = 0
        case tvShows = 1
    }
    
    private var arrayGenres = [Genres]() { didSet { delegate?.reloadData?() } }
    var numberOfGenres: Int { return arrayGenres.count }
    
    private var searchText: String?
    
    // MARK: - Service requests -
    
    func loadData() {
        
    }
    
    func loadData(genreIndex: Int) {
        guard let genreType = GenreType(rawValue: genreIndex) else {
            return
        }
        
        let requestUrl: RequestUrl = genreType == .movies ? .genres: .genresTV
        
        Loading.shared.startLoading()
        serviceModel.getGenres(requestUrl: requestUrl) { [unowned self] (object) in
            Loading.shared.stopLoading()
            
            guard let object = object as? MoviesGenres else {
                return
            }
            
            do {
                try self.showError(with: object)
            } catch {
                guard let error = error as? Error else {
                    return
                }
                self.delegate?.showError?(message: error.message)
                return
            }
            
            guard let results = object.genres else {
                return
            }
            
            self.arrayGenres = results
        }
    }
    
    // MARK: - View Model -
    
    func titleDescription(at indexPath: IndexPath) -> String? {
        return arrayGenres[indexPath.row].name
    }
    
    private func searchResultViewModel(at indexPath: IndexPath) -> SearchResultViewModel? {
        return SearchResultViewModel(selectedGenre: arrayGenres[indexPath.row])
    }
    
    private func searchResultViewModel(with text: String?) -> SearchResultViewModel? {
        return SearchResultViewModel(searchText: text, isMultipleSearch: true)
    }
    
    func searchResultViewModel(at indexPath: IndexPath?, text: String?) -> SearchResultViewModel? {
        if let indexPath = indexPath { return searchResultViewModel(at: indexPath) }
        return searchResultViewModel(with: text)
    }
}
