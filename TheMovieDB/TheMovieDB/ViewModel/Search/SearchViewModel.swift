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
    
    private var arrayGenres = [Genres]() { didSet { if let method = delegate?.reloadData { method() } } }
    var numberOfGenres: Int { return arrayGenres.count }
    
    private var searchText: String?
    
    // MARK: - Service requests -
    
    func loadData(genreIndex: Int) {
        if let genreType = GenreType(rawValue: genreIndex) {
            let requestUrl: RequestUrl = genreType == .movies ? .genres : .genresTV
            
            loadingView.startInWindow()
            serviceModel.getGenres(requestUrl: requestUrl) { (object) in
                self.loadingView.stop()
                if let object = object as? MoviesGenres {
                    if self.showError(with: object) {
                        if let method = self.delegate?.showError { method(object.statusMessage) }
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
    
    func searchResultViewModel(at indexPath: IndexPath) -> SearchResultViewModel? {
        return SearchResultViewModel(selectedGenre: arrayGenres[indexPath.row])
    }
}
