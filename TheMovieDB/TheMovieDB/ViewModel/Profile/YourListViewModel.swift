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
    var user: User
    var isMovieType: Bool {
        return yourListSection != .tvShowsTrack
    }
    
    private var yourListSection: YourListSection
    private var arrayUserMoviesShows: [UserMovieShow] {
        var array = [UserMovieShow]()
    
        switch yourListSection {
        case .wantToSeeMovies:
            array = user.moviesWantToSeeList ?? []
        case .tvShowsTrack:
            array = user.showsTrackList ?? []
        case .seenMovies:
            array = user.moviesSeenList ?? []
        }
        
        isMessageErrorHidden.value = array.count > 0
        return array.sorted(by: { (movieShow1, movieShow2) -> Bool in
            guard let stringDate1 = movieShow1.updateAt,
                let stringDate2 = movieShow2.updateAt,
                let date1 = Date(fromString: stringDate1, format: DateFormatType.isoDateTimeMilliSec),
                let date2 = Date(fromString: stringDate2, format: DateFormatType.isoDateTimeMilliSec) else {
                    
                return true
            }
            
            return date1.isGreaterThan(date: date2)
        })
    }
    
    var numberOfMoviesShows: Int { return arrayUserMoviesShows.count }
    
    // MARK: - Life cycle -
    
    init(object: YourListSection, user: User = Singleton.shared.user) {
        self.yourListSection = object
        self.user = user
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
        let dictionary = [Movie.SerializationKeys.id: userMovie.movieId]
        let movie = Movie(object: dictionary)
        return MovieDetailViewModel(movie)
    }
    
    // MARK: - TV Show Detail -
    
    func tvShowDetailViewModel(at indexPath: IndexPath) -> TVShowDetailViewModel {
        let userShow = arrayUserMoviesShows[indexPath.row]
        let dictionary = [TVShow.SerializationKeys.id: userShow.showId]
        let tvShow = TVShow(object: dictionary)
        return TVShowDetailViewModel(tvShow)
    }
}
