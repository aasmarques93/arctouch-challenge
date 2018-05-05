//
//  SearchViewModel.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

class SearchViewModel: ViewModel {
    // MARK: - Singleton -
    static let shared = SearchViewModel()
    
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
        if let genreType = GenreType(rawValue: genreIndex) {
            let requestUrl: RequestUrl = genreType == .movies ? .genres : .genresTV
            
            Loading.shared.startLoading()
            serviceModel.getGenres(requestUrl: requestUrl) { (object) in
                Loading.shared.stopLoading()
                if let object = object as? MoviesGenres {
                    if self.showError(with: object) {
                        self.delegate?.showError?(message: object.statusMessage)
                        return
                    }
                    
                    if let results = object.genres {
                        self.arrayGenres = results
                    }
                }
            }
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
        if let indexPath = indexPath {
            return searchResultViewModel(at: indexPath)
        }
        return searchResultViewModel(with: text)
    }
}
