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
    let netflixServiceModel = NetflixServiceModel()
    
    // MARK: Delegate
    weak var delegate: ViewModelDelegate?
    
    // MARK: Genre
    
    enum GenreType: Int {
        case movies = 0
        case tvShows = 1
    }
    
    private var arrayGenres = [Genres]() { didSet { delegate?.reloadData?() } }
    var numberOfGenres: Int { return arrayGenres.count }
    
    private var arrayNetflixGenres: [Genres] {
        return Singleton.shared.arrayNetflixGenres
    }
    var numberOfNetflixGenres: Int { return arrayNetflixGenres.count }
    
    private var searchText: String?
    
    // MARK: - Service requests -
    
    init() {
        loadData()
    }
    
    func loadData() {
        getNetflixGenres()
    }
    
    func loadData(genreIndex: Int) {
        guard let genreType = GenreType(rawValue: genreIndex) else {
            return
        }
        
        let requestUrl: RequestUrl = genreType == .movies ? .genres: .genresTV
        
        Loading.shared.start()
        serviceModel.getGenres(requestUrl: requestUrl) { [weak self] (object) in
            Loading.shared.stop()
            
            guard let object = object as? MoviesGenres else {
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
            
            guard let results = object.genres else {
                return
            }
            
            self?.arrayGenres = results
            Singleton.shared.arrayGenres = results
        }
    }
    
    func getNetflixGenres() {
        netflixServiceModel.getNetflixGenres { [weak self] (object) in
            guard let results = object as? [Genres] else {
                return
            }
            
            Singleton.shared.arrayNetflixGenres = results
            self?.delegate?.reloadData?()
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
        return SearchResultViewModel(searchText: text, requestUrl: .multiSearch)
    }
    
    func searchResultViewModel(at indexPath: IndexPath?, text: String?) -> SearchResultViewModel? {
        if let indexPath = indexPath { return searchResultViewModel(at: indexPath) }
        return searchResultViewModel(with: text)
    }
}
