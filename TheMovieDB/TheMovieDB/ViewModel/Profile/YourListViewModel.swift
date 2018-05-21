//
//  YourListViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/19/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class YourListViewModel: ViewModel {
    weak var delegate: ViewModelDelegate?
    
    let serviceModel = YourListServiceModel()
    
    var isMessageErrorHidden = Observable<Bool>(false)
    
    private var yourListSection: YourListSection
    private var arrayUserMovies: [UserMovie] {
        var array = [UserMovie]()
    
        switch yourListSection {
        case .wantToSeeMovies:
            array = Singleton.shared.arrayUserWantToSeeMovies
        case .tvShowsTrack:
            break
        case .seenMovies:
            array = Singleton.shared.arrayUserSeenMovies
        }
        
        isMessageErrorHidden.value = array.count > 0
        return array
    }
    
    var numberOfMovies: Int { return arrayUserMovies.count }
    
    init(object: YourListSection) {
        self.yourListSection = object
    }
    
    func loadData() {
        switch yourListSection {
        case .wantToSeeMovies:
            getUserWantToSeeMovies()
        case .tvShowsTrack:
            return
        case .seenMovies:
            getUserSeenMovies()
        }
    }
    
    func getUserWantToSeeMovies() {
        Singleton.shared.getUserWantToSeeMovies { [weak self] (object) in
            self?.delegate?.reloadData?()
        }
    }
    
    func getUserSeenMovies() {
        Singleton.shared.getUserSeenMovies { [weak self] (object) in
            self?.delegate?.reloadData?()
        }
    }
    
    var isMoviesEmpty: Bool {
        return numberOfMovies == 0
    }
    
    func imagePathUrl(at indexPath: IndexPath) -> URL? {
        return URL(string: serviceModel.imageUrl(with: arrayUserMovies[indexPath.row].movieImageUrl ?? ""))
    }
    
    // MARK: - Movies Detail -
    
    func movieDetailViewModel(at indexPath: IndexPath) -> MovieDetailViewModel {
        let userMovie = arrayUserMovies[indexPath.row]
        let dictionary = ["id": userMovie.movieId]
        let movie = Movie(object: dictionary)
        return MovieDetailViewModel(movie)
    }
}
