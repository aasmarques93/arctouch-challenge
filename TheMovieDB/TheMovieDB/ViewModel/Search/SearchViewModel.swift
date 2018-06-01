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
    private let serviceModel = SearchServiceModel()
    private let netflixServiceModel = NetflixServiceModel()
    
    // MARK: Delegate
    weak var delegate: ViewModelDelegate?
    
    private var arrayGenres = [Genres]() { didSet { delegate?.reloadData?() } }
    var numberOfGenres: Int { return arrayGenres.count }
    
    private var searchText: String?
    
    // MARK: - Service requests -
    
    func loadData() {
        Loading.shared.start()
        serviceModel.getGenres(requestUrl: .genres) { [weak self] (object) in
            Loading.shared.stop()
            
            do {
                try self?.showError(with: object)
            } catch {
                guard let error = error as? Error else {
                    return
                }
                self?.delegate?.showAlert?(message: error.message)
                return
            }
            
            guard let results = object.genres else {
                return
            }
            
            self?.arrayGenres = results
            Singleton.shared.arrayGenres = results
        }
    }
    
    // MARK: - Search Cell -
    
    func titleGenre(at indexPath: IndexPath) -> String? {
        return arrayGenres[indexPath.row].name
    }
    
    func imageUrl(at indexPath: IndexPath) -> URL? {
        let name = arrayGenres[indexPath.row].name ?? ""
        let path = "/image/\(name.replacingOccurrences(of: " ", with: ""))".folding(options: .diacriticInsensitive, locale: nil)
        return URL(string: Singleton.shared.serviceModel.imageUrl(with: path, environmentBase: .heroku))
    }
    
    // MARK: - View Model -
    
    private func searchResultViewModel(at indexPath: IndexPath) -> SearchResultViewModel? {
        return SearchResultViewModel(selectedGenre: arrayGenres[indexPath.row], requestUrl: .searchMovie)
    }
    
    private func searchResultViewModel(with text: String?) -> SearchResultViewModel? {
        return SearchResultViewModel(searchText: text, requestUrl: .multiSearch)
    }
    
    func searchResultViewModel(at indexPath: IndexPath?, text: String?) -> SearchResultViewModel? {
        if let indexPath = indexPath { return searchResultViewModel(at: indexPath) }
        return searchResultViewModel(with: text)
    }
}
