//
//  MovieDetailViewModel.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

protocol MovieDetailViewModelDelegate: class {
    func reloadData()
    func reloadVideos()
    func reloadRecommendedMovies()
}

class MovieDetailViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: MovieDetailViewModelDelegate?
    
    // MARK: Observables
    var name = Observable<String?>(nil)
    var average = Observable<String?>(nil)
    var date = Observable<String?>(nil)
    var runtime = Observable<String?>(nil)
    var genres = Observable<String?>(nil)
    var overview = Observable<String?>(nil)
    
    // MARK: Objects
    var object: Movie!
    private var movieDetail: MovieDetail? {
        didSet {
            delegate?.reloadData()
            
            name.value = valueDescription(movieDetail?.originalTitle)
            date.value = valueDescription(movieDetail?.releaseDate)
            average.value = valueDescription(movieDetail?.voteAverage)
            runtime.value = "\(valueDescription(movieDetail?.runtime)) minutes"
            overview.value = valueDescription(movieDetail?.overview)
            
            genres.value = setupGenres()
        }
    }
    
    private var videosList = [Video]() { didSet { delegate?.reloadVideos() } }
    var numberOfVideos: Int { return videosList.count }
    
    private var moviesRecommendationsList = [Movie]() { didSet { delegate?.reloadRecommendedMovies() } }
    var numberOfMoviesRecommendations: Int { return moviesRecommendationsList.count }
    
    // MARK: - Life cycle -
    
    init(_ object: Movie) {
        super.init()
        self.object = object
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        getMovieDetail()
        getVideos()
        getMovieRecommendations()
    }
    
    func getMovieDetail() {
        if let value = object.id {
            let parameters = ["idMovie": value]
            
            loadingView.startInWindow()
            MovieDetailServiceModel.shared.getMovieDetail(urlParameters: parameters) { (object) in
                self.loadingView.stop()
                self.movieDetail = object as? MovieDetail
            }
        }
    }
    
    func getVideos() {
        if let value = object.id {
            let parameters = ["idMovie": value]
            
            MovieDetailServiceModel.shared.getMovieVideos(urlParameters: parameters) { (object) in
                if let object = object as? VideosList {
                    if let results = object.results {
                        self.videosList.append(contentsOf: results)
                    }
                }
            }
        }
    }
    
    func getMovieRecommendations() {
        if let value = object.id {
            let parameters = ["idMovie": value, "page": 1]
            
            MovieDetailServiceModel.shared.getMovieRecommendations(urlParameters: parameters) { (object) in
                if let object = object as? MoviesList {
                    if let results = object.results {
                        self.moviesRecommendationsList.append(contentsOf: results)
                    }
                }
            }
        }
    }
    
    //MARK: - View Model -
    
    func movieName() -> String? {
        return object.originalTitle
    }
    
    func imagesData(handlerBackgroundData: @escaping HandlerObject, handlerPosterData: @escaping HandlerObject) {
        if let movieDetail = movieDetail {
            HomeServiceModel.shared.loadImage(path: movieDetail.backdropPath, handlerData: { (data) in
                handlerBackgroundData(data)
            })
            HomeServiceModel.shared.loadImage(path: movieDetail.posterPath, handlerData: { (data) in
                handlerPosterData(data)
            })
        }
    }
    
    func setupGenres() -> String {
        var string = ""
        if let array = movieDetail?.genres {
            var count = 0
            for genre in array {
                string += valueDescription(genre.name)
                if count < array.count-1 { string += ", " }
                count += 1
            }
        }
        return string
    }
    
    func videoTitle(at index: Int) -> String? {
        return videosList[index].name
    }
    
    func videoYouTubeId(at index: Int) -> String? {
        return videosList[index].key
    }
    
    func movieRecommendationImageData(at index: Int, handlerData: @escaping HandlerObject) {
        let movie = moviesRecommendationsList[index]
        
        if let data = movie.imageData {
            handlerData(data)
            return
        }
        
        HomeServiceModel.shared.loadImage(path: movie.posterPath, handlerData: { (data) in
            self.moviesRecommendationsList[index].imageData = data as? Data
            handlerData(data)
        })
    }
    
    func movieDetailViewModel(at index: Int) -> MovieDetailViewModel? {
        let movie = moviesRecommendationsList[index]
        return MovieDetailViewModel(movie)
    }
}
