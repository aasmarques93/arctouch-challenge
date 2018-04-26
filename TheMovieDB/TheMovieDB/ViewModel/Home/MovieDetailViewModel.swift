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
    func reloadSimilarMovies()
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
    var movie: Movie!
    
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
    
    let serviceModel = MovieDetailServiceModel.shared
    
    // MARK: Videos
    
    private var videosList = [Video]() { didSet { delegate?.reloadVideos() } }
    var numberOfVideos: Int { return videosList.count }
    
    // MARK: Recommended
    
    private var moviesRecommendationsList = [Movie]() { didSet { delegate?.reloadRecommendedMovies() } }
    var numberOfMoviesRecommendations: Int { return moviesRecommendationsList.count }
    
    // MARK: Similar Movies
    
    private var similarMoviesList = [Movie]() { didSet { delegate?.reloadSimilarMovies() } }
    var numberOfSimilarMovies: Int { return similarMoviesList.count }
    
    // MARK: - Life cycle -
    
    init(_ object: Movie) {
        super.init()
        self.movie = object
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        getMovieDetail()
        getVideos()
        getMovieRecommendations()
        getSimilarMovies()
    }
    
    private func getMovieDetail() {
        loadingView.startInWindow()
        serviceModel.getDetail(from: movie) { (object) in
            self.loadingView.stop()
            self.movieDetail = object as? MovieDetail
        }
    }
    
    private func getVideos() {
        serviceModel.getVideos(from: movie) { (object) in
            if let object = object as? VideosList {
                if let results = object.results {
                    self.videosList.append(contentsOf: results)
                }
            }
        }
    }
    
    private func getMovieRecommendations() {
        serviceModel.getRecommendations(from: movie) { (object) in
            if let object = object as? MoviesList {
                if let results = object.results {
                    self.moviesRecommendationsList.append(contentsOf: results)
                }
            }
        }
    }
    
    private func getSimilarMovies() {
        serviceModel.getSimilar(from: movie) { (object) in
            if let object = object as? MoviesList {
                if let results = object.results {
                    self.similarMoviesList.append(contentsOf: results)
                }
            }
        }
    }
    
    //MARK: - View Model -
    
    var movieName: String? {
        return movie.originalTitle
    }
    
    func movieDetailImageData(handlerData: @escaping HandlerObject) {
        if let movieDetail = movieDetail {
            serviceModel.loadImage(path: movieDetail.backdropPath, handlerData: { (data) in
                handlerData(data)
            })
        }
    }
    
    private func setupGenres() -> String {
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
        loadImageData(from: movie) { (data) in
            handlerData(data)
        }
    }
    
    func similarMovieImageData(at index: Int, handlerData: @escaping HandlerObject) {
        let movie = similarMoviesList[index]
        loadImageData(from: movie) { (data) in
            handlerData(data)
        }
    }
    
    private func loadImageData(from movie: Movie, handlerData: @escaping HandlerObject) {
        if let data = movie.imageData {
            handlerData(data)
            return
        }
        
        serviceModel.loadImage(path: movie.posterPath, handlerData: { (data) in
            movie.imageData = data as? Data
            handlerData(data)
        })
    }
    
    func recommendedMovieDetailViewModel(at index: Int) -> MovieDetailViewModel? {
        return movieDetailViewModel(moviesRecommendationsList[index])
    }
    
    func similarMovieDetailViewModel(at index: Int) -> MovieDetailViewModel? {
        return movieDetailViewModel(similarMoviesList[index])
    }
    
    private func movieDetailViewModel(_ movie: Movie) -> MovieDetailViewModel? {
        return MovieDetailViewModel(movie)
    }
}
