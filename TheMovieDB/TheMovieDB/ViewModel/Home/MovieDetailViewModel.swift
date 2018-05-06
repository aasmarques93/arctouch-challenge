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
            
            name.value = valueDescription(movieDetail?.originalTitle)
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
    private var videosList = [Video]() { didSet { delegate?.reloadVideos() } }
    var numberOfVideos: Int { return videosList.count }
    
    // MARK: Recommended
    private var moviesRecommendationsList = [Movie]() { didSet { delegate?.reloadRecommendedMovies() } }
    var numberOfMoviesRecommendations: Int { return moviesRecommendationsList.count }
    
    // MARK: Similar Movies
    private var similarMoviesList = [Movie]() { didSet { delegate?.reloadSimilarMovies() } }
    var numberOfSimilarMovies: Int { return similarMoviesList.count }
    
    // MARK: Cast
    private var castList = [Cast]() { didSet { delegate?.reloadCast() } }
    var numberOfCastCharacters: Int { return castList.count }
    
    // MARK: Reviews
    private var reviewsList = [Review]() { didSet { delegate?.reloadReviews() } }
    var numberOfReviews: Int { return reviewsList.count }
    
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
            
            guard let strongSelf = self else {
                return
            }
            strongSelf.movieDetail = object as? MovieDetail
        }
    }
    
    private func getVideos() {
        guard videosList.isEmpty else {
            return
        }
        
        serviceModel.getVideos(from: movie) { [weak self] (object) in
            guard let strongSelf = self else {
                return
            }
            guard let object = object as? VideosList, let results = object.results else {
                return
            }
            
            strongSelf.videosList.append(contentsOf: results)
        }
    }
    
    private func getMovieRecommendations() {
        guard moviesRecommendationsList.isEmpty else {
            return
        }
        
        serviceModel.getRecommendations(from: movie) { [weak self] (object) in
            guard let strongSelf = self else {
                return
            }
            guard let object = object as? MoviesList, let results = object.results else {
                return
            }
            
            strongSelf.moviesRecommendationsList.append(contentsOf: results)
        }
    }
    
    private func getSimilarMovies() {
        guard similarMoviesList.isEmpty else {
            return
        }
        
        serviceModel.getSimilar(from: movie) { [weak self] (object) in
            guard let strongSelf = self else {
                return
            }
            guard let object = object as? MoviesList, let results = object.results else {
                return
            }
            
            strongSelf.similarMoviesList.append(contentsOf: results)
        }
    }
    
    private func getCredits() {
        guard castList.isEmpty else {
            return
        }
        
        serviceModel.getCredits(from: movie) { [weak self] (object) in
            guard let strongSelf = self else {
                return
            }
            guard let object = object as? CreditsList, let results = object.cast else {
                return
            }
            
            strongSelf.castList.append(contentsOf: results)
        }
    }
    
    private func getReviews() {
        guard reviewsList.isEmpty else {
            return
        }
        
        serviceModel.getReviews(from: movie) { [weak self] (object) in
            guard let strongSelf = self else {
                return
            }
            guard let object = object as? ReviewsList, let results = object.results else {
                return
            }
            
            strongSelf.reviewsList.append(contentsOf: results)
        }
    }
    
    // MARK: - View Model -
    
    // MARK: Movie
    
    var movieName: String? {
        return movie.originalTitle
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
        return videosList[index].name
    }
    
    func videoYouTubeId(at index: Int) -> String? {
        return videosList[index].key
    }
    
    // MARK: Recommendations
    
    func movieRecommendationImageData(at index: Int, handlerData: @escaping HandlerObject) {
        var movie = moviesRecommendationsList[index]
        
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
        var movie = similarMoviesList[index]
        
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
        var cast = castList[index]
        
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
        return castList[index].name ?? ""
    }
    
    func castCharacter(at index: Int) -> String {
        return castList[index].character ?? ""
    }
    
    // MARK: Reviews
    
    func reviewAuthor(at index: Int) -> String {
        return reviewsList[index].author ?? ""
    }
    
    func reviewContent(at index: Int) -> String {
        return reviewsList[index].content ?? ""
    }
    
    // MARK: - View Model Instantiation -
    
    func recommendedMovieDetailViewModel(at index: Int) -> MovieDetailViewModel? {
        return movieDetailViewModel(moviesRecommendationsList[index])
    }
    
    func similarMovieDetailViewModel(at index: Int) -> MovieDetailViewModel? {
        return movieDetailViewModel(similarMoviesList[index])
    }
    
    private func movieDetailViewModel(_ movie: Movie) -> MovieDetailViewModel? {
        return MovieDetailViewModel(movie)
    }
    
    func personViewModel(at index: Int) -> PersonViewModel? {
        return PersonViewModel(castList[index].id)
    }
}
