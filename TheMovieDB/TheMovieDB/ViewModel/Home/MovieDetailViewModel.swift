//
//  MovieDetailViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

protocol MovieDetailViewModelDelegate: ViewModelDelegate {
    func reloadVideos()
    func reloadRecommendedMovies()
    func reloadSimilarMovies()
    func reloadCast()
    func reloadReviews()
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
    
    var movieDetail: MovieDetail? {
        didSet {
            delegate?.reloadData?()
            
            name.value = valueDescription(movieDetail?.title)
            date.value = valueDescription(movieDetail?.releaseDate)
            average.value = valueDescription(movieDetail?.voteAverage)
            runtime.value = "\(valueDescription(movieDetail?.runtime)) minutes"
            overview.value = valueDescription(movieDetail?.overview)
            
            genres.value = setupGenres()
        }
    }
    
    // MARK: Service Model
    let serviceModel = MovieDetailServiceModel()
    
    // MARK: Videos
    private var arrayVideos = [Video]() { didSet { delegate?.reloadVideos() } }
    var numberOfVideos: Int { return arrayVideos.count }
    
    // MARK: Recommended
    private var arrayMovieRecommendations = [Movie]() { didSet { delegate?.reloadRecommendedMovies() } }
    var numberOfMoviesRecommendations: Int { return arrayMovieRecommendations.count }
    
    // MARK: Similar Movies
    private var arraySimilarMovies = [Movie]() { didSet { delegate?.reloadSimilarMovies() } }
    var numberOfSimilarMovies: Int { return arraySimilarMovies.count }
    
    // MARK: Cast
    private var arrayCast = [Cast]() { didSet { delegate?.reloadCast() } }
    var numberOfCastCharacters: Int { return arrayCast.count }
    
    // MARK: Reviews
    private var arrayReviews = [Review]() { didSet { delegate?.reloadReviews() } }
    var numberOfReviews: Int { return arrayReviews.count }
    
    // MARK: - Life cycle -
    
    init(_ object: Movie) {
        self.movie = object
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        getMovieDetail()
        getVideos()
        getMovieRecommendations()
        getSimilarMovies()
        getCredits()
        getReviews()
    }
    
    private func getMovieDetail() {
        Loading.shared.startLoading()
        serviceModel.getDetail(from: movie) { [weak self] (object) in
            Loading.shared.stopLoading()
            self?.movieDetail = object as? MovieDetail
        }
    }
    
    private func getVideos() {
        guard arrayVideos.isEmpty else {
            return
        }
        
        serviceModel.getVideos(from: movie) { [weak self] (object) in
            guard let object = object as? VideosList, let results = object.results else {
                return
            }
            
            self?.arrayVideos.append(contentsOf: results)
        }
    }
    
    private func getMovieRecommendations() {
        guard arrayMovieRecommendations.isEmpty else {
            return
        }
        
        serviceModel.getRecommendations(from: movie) { [weak self] (object) in
            guard let object = object as? MoviesList, let results = object.results else {
                return
            }
            
            self?.arrayMovieRecommendations.append(contentsOf: results)
        }
    }
    
    private func getSimilarMovies() {
        guard arraySimilarMovies.isEmpty else {
            return
        }
        
        serviceModel.getSimilar(from: movie) { [weak self] (object) in
            guard let object = object as? MoviesList, let results = object.results else {
                return
            }
            
            self?.arraySimilarMovies.append(contentsOf: results)
        }
    }
    
    private func getCredits() {
        guard arrayCast.isEmpty else {
            return
        }
        
        serviceModel.getCredits(from: movie) { [weak self] (object) in
            guard let object = object as? CreditsList, let results = object.cast else {
                return
            }
            
            self?.arrayCast.append(contentsOf: results)
        }
    }
    
    private func getReviews() {
        guard arrayReviews.isEmpty else {
            return
        }
        
        serviceModel.getReviews(from: movie) { [weak self] (object) in
            guard let object = object as? ReviewsList, let results = object.results else {
                return
            }
            
            self?.arrayReviews.append(contentsOf: results)
        }
    }
    
    // MARK: - View Model -
    
    // MARK: Movie
    
    var movieName: String? {
        return movie.title
    }
    
    func movieDetailImageData(handlerData: @escaping HandlerObject) {
        guard let movieDetail = movieDetail else {
            return
        }
        
        serviceModel.loadImage(path: movieDetail.backdropPath, handlerData: { (data) in
            handlerData(data)
        })
    }
    
    private func setupGenres() -> String {
        var string = ""
        if let array = movieDetail?.genres {
            let arrayNames = array.map { return valueDescription($0.name) }
            string = arrayNames.joined(separator: ", ")
        }
        return string
    }
    
    // MARK: Videos
    
    func videoTitle(at index: Int) -> String? {
        return arrayVideos[index].name
    }
    
    func videoYouTubeId(at index: Int) -> String? {
        return arrayVideos[index].key
    }
    
    // MARK: Recommendations
    
    func movieRecommendationImageData(at index: Int, handlerData: @escaping HandlerObject) {
        var movie = arrayMovieRecommendations[index]
        
        if let data = movie.imageData {
            handlerData(data)
            return
        }
        
        serviceModel.loadImage(path: movie.posterPath ?? "", handlerData: { (data) in
            movie.imageData = data as? Data
            handlerData(data)
        })
    }
    
    // MARK: Similar
    
    func similarMovieImageData(at index: Int, handlerData: @escaping HandlerObject) {
        var movie = arraySimilarMovies[index]
        
        if let data = movie.imageData {
            handlerData(data)
            return
        }
        
        serviceModel.loadImage(path: movie.posterPath ?? "", handlerData: { (data) in
            movie.imageData = data as? Data
            handlerData(data)
        })
    }
    
    // MARK: Cast
    
    func castImageData(at index: Int, handlerData: @escaping HandlerObject) {
        var cast = arrayCast[index]
        
        if let data = cast.imageData {
            handlerData(data)
            return
        }
        
        serviceModel.loadImage(path: cast.profilePath ?? "", handlerData: { (data) in
            cast.imageData = data as? Data
            handlerData(data)
        })
    }
    
    func castName(at index: Int) -> String {
        return arrayCast[index].name ?? ""
    }
    
    func castCharacter(at index: Int) -> String {
        return arrayCast[index].character ?? ""
    }
    
    // MARK: Reviews
    
    func reviewAuthor(at index: Int) -> String {
        return arrayReviews[index].author ?? ""
    }
    
    func reviewContent(at index: Int) -> String {
        return arrayReviews[index].content ?? ""
    }
    
    // MARK: - View Model Instantiation -
    
    func recommendedMovieDetailViewModel(at index: Int) -> MovieDetailViewModel? {
        return movieDetailViewModel(arrayMovieRecommendations[index])
    }
    
    func similarMovieDetailViewModel(at index: Int) -> MovieDetailViewModel? {
        return movieDetailViewModel(arraySimilarMovies[index])
    }
    
    private func movieDetailViewModel(_ movie: Movie) -> MovieDetailViewModel? {
        return MovieDetailViewModel(movie)
    }
    
    func personViewModel(at index: Int) -> PersonViewModel? {
        return PersonViewModel(arrayCast[index].id)
    }
}
