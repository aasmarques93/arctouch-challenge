//
//  TVShowViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

protocol TVShowViewModelDelegate: class {
    func reloadData()
}

class TVShowViewModel: ViewModel {
    // MARK: - Singleton -
    static let shared = TVShowViewModel()
    
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: TVShowViewModelDelegate?
    
    // MARK: Service Model
    let serviceModel = TVShowServiceModel()
    
    // MARK: Popular
    private var popularList = [Movie]()
    var numberOfPopularList: Int { return popularList.count }
    private var currentPage: Int = 1
    
    // MARK: Variables
    private var isDataLoading = false
    
    // MARK: - Service requests -
    
    func loadData() {
        getPopular()
    }
    
    private func getPopular() {
        isDataLoading = true
        
        loadingView.startInWindow()
        
        let parameters = ["page": currentPage]
        serviceModel.getPopular(urlParameters: parameters) { (object) in
            self.loadingView.stop()
            
            if let object = object as? MoviesList, let results = object.results {
                self.popularList.append(contentsOf: results)
            }
            
            self.delegate?.reloadData()
            self.isDataLoading = false
        }
    }
    
    func doServicePaginationIfNeeded(at indexPath: IndexPath) {
        if indexPath.row == popularList.count-2 && !isDataLoading {
            currentPage += 1
            loadData()
        }
    }
    
    //MARK: View model
    
    func tvShowCellViewModel(at indexPath: IndexPath) -> TVShowCellViewModel? {
        return TVShowCellViewModel(popularList[indexPath.row])
    }
    
    func tvShowDetailViewModel(at indexPath: IndexPath) -> TVShowDetailViewModel? {
        return TVShowDetailViewModel(popularList[indexPath.row].id)
    }
}
