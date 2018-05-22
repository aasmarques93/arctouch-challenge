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
    
    var isMovieType: Bool {
        return yourListSection != .tvShowsTrack
    }
    
    private var yourListSection: YourListSection
    private var arrayUserMoviesShows: [UserMovieShow] {
        var array = [UserMovieShow]()
    
        switch yourListSection {
        case .wantToSeeMovies:
            array = Singleton.shared.arrayUserWantToSeeMovies
        case .tvShowsTrack:
            array = Singleton.shared.arrayUserShows
        case .seenMovies:
            array = Singleton.shared.arrayUserSeenMovies
        }
        
        isMessageErrorHidden.value = array.count > 0
        return array
    }
    
    var numberOfMoviesShows: Int { return arrayUserMoviesShows.count }
    
    init(object: YourListSection) {
        self.yourListSection = object
    }
    
    func loadData() {
        switch yourListSection {
        case .wantToSeeMovies:
            getUserWantToSeeMovies()
        case .tvShowsTrack:
            getUserShows()
        case .seenMovies:
            getUserSeenMovies()
        }
    }
    
    func getUserWantToSeeMovies() {
        Singleton.shared.getUserWantToSeeMovies { [weak self] (object) in
            self?.delegate?.reloadData?()
        }
    }
    
    func getUserShows() {
        Singleton.shared.getUserShows { [weak self] (object) in
            self?.delegate?.reloadData?()
        }
    }
    
    func getUserSeenMovies() {
        Singleton.shared.getUserSeenMovies { [weak self] (object) in
            self?.delegate?.reloadData?()
        }
    }
    
    var isMoviesEmpty: Bool {
        return numberOfMoviesShows == 0
    }
    
    func imagePathUrl(at indexPath: IndexPath) -> URL? {
        guard isMovieType else {
            return URL(string: serviceModel.imageUrl(with: arrayUserMoviesShows[indexPath.row].showImageUrl ?? ""))
        }
        return URL(string: serviceModel.imageUrl(with: arrayUserMoviesShows[indexPath.row].movieImageUrl ?? ""))
    }
    
    // MARK: - Movies Detail -
    
    func movieDetailViewModel(at indexPath: IndexPath) -> MovieDetailViewModel {
        let userMovie = arrayUserMoviesShows[indexPath.row]
        let dictionary = ["id": userMovie.movieId]
        let movie = Movie(object: dictionary)
        return MovieDetailViewModel(movie)
    }
    
    func tvShowDetailViewModel(at indexPath: IndexPath) -> TVShowDetailViewModel {
        let userShow = arrayUserMoviesShows[indexPath.row]
        let dictionary = ["id": userShow.showId]
        let tvShow = TVShow(object: dictionary)
        return TVShowDetailViewModel(tvShow)
    }
}
