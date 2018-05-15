//
//  MoviesShowsViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/15/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

protocol MoviesShowsViewModelDelegate: ViewModelDelegate {
    func reloadData(at index: Int)
    func openPreview(storiesViewModel: StoriesViewModel)
}

class MoviesShowsViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: MoviesShowsViewModelDelegate?
    
    // MARK: Service Model
    let moviesServiceModel = MoviesServiceModel()
    let tvShowServiceModel = TVShowServiceModel()
    let netflixServiceModel = NetflixServiceModel()
    
    // MARK: Netflix
    var arrayNetflix = [Netflix]() { didSet { delegate?.reloadData?() } }
    var numberOfNeflix: Int { return arrayNetflix.count }
    
    var arrayStoriesPages = [StoriesPageItem]()
    
    // MARK: Variables
    var isDataLoading = false
    var isMovie: Bool
    
    init(isMovie: Bool = true) {
        self.isMovie = isMovie
    }
    
    func loadData() {
        getNetflixMoviesShows()
    }
    
    func getNetflixMoviesShows() {
        guard let userPersonalityType = Singleton.shared.userPersonalityType, let genres = userPersonalityType.netflixGenres else {
            return
        }
        
        arrayNetflix = [Netflix]()
        genres.forEach { [weak self] (genre) in
            self?.getNetflixMoviesShowsGenres(id: genre)
        }
    }
    
    func getNetflixMoviesShowsGenres(id: Int?) {
        netflixServiceModel.getNetflixMoviesShow(genre: id, isMovie: isMovie) { [weak self] (object) in
            guard let result = object as? [Netflix] else {
                return
            }
            let sortedArray = result.sorted(by: { (movie1, movie2) -> Bool in
                guard let rating1 = movie1.imdbRating, let rating2 = movie2.imdbRating else {
                    return true
                }
                return rating1 > rating2
            })
            self?.arrayNetflix.append(contentsOf: sortedArray)
            self?.reloadData(at: 0)
        }
    }
    
    func getMoviesFromGenre(id: Int?, handler: @escaping HandlerObject) {
        guard let value = id else {
            return
        }
        
        let parameters: [String: Any] = [
            "id": value,
            "language": Locale.preferredLanguages.first ?? ""
        ]
        SearchServiceModel().getMoviesFromGenre(urlParameters: parameters) { (object) in
            handler(object)
        }
    }
    
    func sortedByVoteAverage(array: [Movie]) -> [Movie] {
        let sortedArray = array.sorted(by: { (movie1, movie2) -> Bool in
            guard let voteAverage1 = movie1.voteAverage, let voteAverage2 = movie2.voteAverage else {
                return true
            }
            return voteAverage1 > voteAverage2
        })
        
        return sortedArray
    }
    
    func reloadData(at index: Int) {
        delegate?.reloadData(at: index)
        isDataLoading = false
    }
    
    func storyPreviewImagePathUrl(at index: Int) -> URL? {
        let netflix = arrayNetflix[index]
        return URL(string: netflixServiceModel.imageUrl(with: netflix.id, isMovie: isMovie))
    }
    
    func loadVideos(at index: Int) {
        delegate?.openPreview(storiesViewModel: StoriesViewModel(arrayNetflix, selectedIndex: index, isMovie: isMovie))
    }
    
    func searchResultViewModel(with text: String?) -> SearchResultViewModel? {
        return SearchResultViewModel(searchText: text, requestUrl: isMovie ? .searchMovie : .searchTV)
    }
}
