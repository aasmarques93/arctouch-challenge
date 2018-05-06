//
//  PopularPeopleViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class PopularPeopleViewModel: ViewModel {
    // MARK: - Singleton -
    static let shared = PopularPeopleViewModel()
    
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: ViewModelDelegate?
    
    // MARK: Observables
    var isEmptyMessageHidden = Observable<Bool>(false)
    
    // MARK: Service Model
    let serviceModel = PopularPeopleServiceModel()
    
    // MARK: Variables
    private var isDataLoading = false
    private var currentPage: Int = 1
    private var searchText: String?
    private var totalPages: Int?
    
    // MARK: Objects
    private var arrayPopularPeople = [Person]()
    private var arraySearchPerson = [Person]() {
        didSet {
            isEmptyMessageHidden.value = numberOfPopularPeople > 0
            delegate?.reloadData?()
        }
    }
    var numberOfPopularPeople: Int { return arraySearchPerson.count }
    
    // MARK: - Service requests -
    
    func loadData() {
        if let searchText = searchText, !searchText.isEmptyOrWhitespace { return }
        
        isDataLoading = true
        
        let parameters = ["page": currentPage]
        serviceModel.getPopularPeople(urlParameters: parameters) { [unowned self] (object) in
            if let object = object as? PopularPeople, let results = object.results {
                self.totalPages = object.totalPages
                self.arrayPopularPeople.append(contentsOf: results)
            }
            
            self.isDataLoading = false
            self.arraySearchPerson = self.arrayPopularPeople
        }
    }
    
    func doServicePaginationIfNeeded(at indexPath: IndexPath) {
        if indexPath.row == arraySearchPerson.count-2 && !isDataLoading {
            currentPage += 1
            
            guard let totalPages = totalPages, currentPage < totalPages else {
                return
            }
            
            loadData()
        }
    }
    
    func doSearchPerson(with text: String?) {
        searchText = text
        currentPage = 1
        
        if let value = searchText, !value.isEmptyOrWhitespace {
            let parameters: [String:Any] = ["query": value.replacingOccurrences(of: " ", with: "%20"), "page": currentPage]
            
            serviceModel.doSearchPerson(urlParameters: parameters) { [unowned self] (object) in
                guard let object = object as? SearchPerson, let results = object.results else {
                    return
                }
                
                self.arraySearchPerson = results
            }
            
            return
        }
        
        loadData()
    }
    
    // MARK: - View Model -
    
    func popularPersonCellViewModel(at indexPath: IndexPath) -> PopularPersonCellViewModel? {
        return PopularPersonCellViewModel(arraySearchPerson[indexPath.row])
    }
    
    func personViewModel(at indexPath: IndexPath) -> PersonViewModel? {
        return PersonViewModel(arraySearchPerson[indexPath.row].id)
    }
}
