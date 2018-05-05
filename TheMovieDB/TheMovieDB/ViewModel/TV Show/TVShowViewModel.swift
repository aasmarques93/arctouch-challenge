//
//  TVShowViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

class TVShowViewModel: ViewModel {
    // MARK: - Singleton -
    static let shared = TVShowViewModel()
    
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: ViewModelDelegate?
    
    // MARK: Service Model
    let serviceModel = TVShowServiceModel()
    
    // MARK: Variables
    private var isDataLoading = false
    private var currentPage: Int = 1
    private var searchText: String?
    private var totalPages: Int?
    
    // MARK: Objects
    private var popularList = [TVShow]()
    private var searchPopularList = [TVShow]() { didSet { delegate?.reloadData?() } }
    var numberOfPopularList: Int { return searchPopularList.count }
    
    var isTVShowsEmpty: Bool { return numberOfPopularList == 0 }
    
    // MARK: - Service requests -
    
    func loadData() {
        if let searchText = searchText, !searchText.isEmptyOrWhitespace { return }
        
        isDataLoading = true
        
        let parameters = ["page": currentPage]
        serviceModel.getPopular(urlParameters: parameters) { [weak self] (object) in
            guard let strongSelf = self else {
                return
            }
            
            if let object = object as? SearchTV, let results = object.results {
                strongSelf.totalPages = object.totalPages
                strongSelf.popularList.append(contentsOf: results)
            }
            
            strongSelf.isDataLoading = false
            strongSelf.searchPopularList = strongSelf.popularList
        }
    }
    
    func doServicePaginationIfNeeded(at indexPath: IndexPath) {
        if indexPath.row == searchPopularList.count-2 && !isDataLoading {
            currentPage += 1
            
            guard let totalPages = totalPages, currentPage < totalPages else {
                return
            }
            loadData()
        }
    }
    
    func doSearchTVShow(with text: String?) {
        searchText = text
        currentPage = 1
        
        if let value = searchText, !value.isEmptyOrWhitespace {
            let parameters: [String:Any] = ["query": value.replacingOccurrences(of: " ", with: "%20"), "page": currentPage]
            
            Loading.shared.startLoading()
            serviceModel.doSearchTVShow(urlParameters: parameters) { [weak self] (object) in
                Loading.shared.stopLoading()
                
                guard let strongSelf = self else {
                    return
                }
                guard let object = object as? SearchTV, let results = object.results else {
                    return
                }
                
                strongSelf.searchPopularList = results
            }
            
            return
        }
        
        loadData()
    }
    
    //MARK: View model
    
    func tvShowCellViewModel(at indexPath: IndexPath) -> TVShowCellViewModel? {
        return TVShowCellViewModel(searchPopularList[indexPath.row])
    }
    
    func tvShowDetailViewModel(at indexPath: IndexPath) -> TVShowDetailViewModel? {
        return TVShowDetailViewModel(searchPopularList[indexPath.row].id)
    }
}
