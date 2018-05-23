//
//  YourListViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/19/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class YourListViewModel: ViewModel {
    // MARK: - Delegate -
    weak var delegate: ViewModelDelegate?
    
    // MARK: - Service Model -
    let serviceModel = YourListServiceModel()
    
    // MARK: - Observables -
    var isMessageErrorHidden = Observable<Bool>(false)
    
    // MARK: - Objects -
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
    
    // MARK: - Life cycle -
    
    init(object: YourListSection) {
        self.yourListSection = object
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        Singleton.shared.loadUserData { [weak self] (object) in
            self?.delegate?.reloadData?()
        }
    }
    
    // MARK: - Movies Shows -
    
    var isMoviesShowsEmpty: Bool {
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
    
    // MARK: - TV Show Detail -
    
    func tvShowDetailViewModel(at indexPath: IndexPath) -> TVShowDetailViewModel {
        let userShow = arrayUserMoviesShows[indexPath.row]
        let dictionary = ["id": userShow.showId]
        let tvShow = TVShow(object: dictionary)
        return TVShowDetailViewModel(tvShow)
    }
}
