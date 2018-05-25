//
//  SearchCellViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/25/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class SearchCellViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Observables
    var photo = Observable<UIImage?>(nil)
    var title = Observable<String?>(nil)

    var genre: Genres
    
    init(object: Genres) {
        genre = object
    }
    
    func loadData() {
        title.value = genre.name
        
        if photo.value != nil {
            return
        }
        
        let path = genre.name ?? ""
        Singleton.shared.serviceModel.loadImage(path: "/image/\(path.replacingOccurrences(of: " ", with: ""))", environmentBase: .heroku) { [weak self] (data) in
            guard let data = data as? Data else {
                return
            }
            
            self?.photo.value = UIImage(data: data)
        }
    }
}
