//
//  SearchViewModel.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

protocol SearchViewModelDelegate: class {
    func reloadData()
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
    
    // MARK: - View Model -
    
    func titleDescription(at indexPath: IndexPath) -> String? {
        return arrayGenres[indexPath.row].name
    }
    
    func searchResultViewModel(at indexPath: IndexPath) -> SearchResultViewModel? {
        return SearchResultViewModel(selectedGenre: arrayGenres[indexPath.row])
    }
}
