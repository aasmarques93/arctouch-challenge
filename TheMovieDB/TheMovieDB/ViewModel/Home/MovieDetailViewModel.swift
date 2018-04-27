//
//  MovieDetailViewModel.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

protocol MovieDetailViewModelDelegate: class {
    func reloadData()
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
            delegate?.reloadData()
            
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
        super.init()
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
        loadingView.startInWindow()
        serviceModel.getDetail(from: movie) { (object) in
            self.loadingView.stop()
            self.movieDetail = object as? MovieDetail
        }
    }
    
    private func getVideos() {
        if videosList.isEmpty {
            serviceModel.getVideos(from: movie) { (object) in
                if let object = object as? VideosList, let results = object.results {
                    self.videosList.append(contentsOf: results)
                }
            }
        }
    }
    
    private func getMovieRecommendations() {
        if moviesRecommendationsList.isEmpty {
            serviceModel.getRecommendations(from: movie) { (object) in
                if let object = object as? MoviesList, let results = object.results {
                    self.moviesRecommendationsList.append(contentsOf: results)
                }
            }
        }
    }
    
    private func getSimilarMovies() {
        if similarMoviesList.isEmpty {
            serviceModel.getSimilar(from: movie) { (object) in
                if let object = object as? MoviesList, let results = object.results {
                    self.similarMoviesList.append(contentsOf: results)
                }
            }
        }
    }
    
    private func getCredits() {
        if castList.isEmpty {
            serviceModel.getCredits(from: movie) { (object) in
                if let object = object as? CreditsList, let results = object.cast {
                    self.castList.append(contentsOf: results)
                }
            }
        }
    }
    
    private func getReviews() {
        if reviewsList.isEmpty {
            serviceModel.getReviews(from: movie) { (object) in
                if let object = object as? ReviewsList, let results = object.results {
                    self.reviewsList.append(contentsOf: results)
                }
            }
        }
    }
    
    // MARK: - View Model -
    
    // MARK: Movie
    
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
        let movie = moviesRecommendationsList[index]
        loadImageData(from: movie) { (data) in
            handlerData(data)
        }
    }
    
    // MARK: Similar
    
    func similarMovieImageData(at index: Int, handlerData: @escaping HandlerObject) {
        let movie = similarMoviesList[index]
        loadImageData(from: movie) { (data) in
            handlerData(data)
        }
    }
    
    // MARK: Cast
    
    func castImageData(at index: Int, handlerData: @escaping HandlerObject) {
        let cast = castList[index]
        
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
    
    // MARK: Class
    
    private func loadImageData(from movie: Movie, handlerData: @escaping HandlerObject) {
        if let data = movie.imageData {
            handlerData(data)
            return
        }
        
        serviceModel.loadImage(path: movie.posterPath ?? "", handlerData: { (data) in
            movie.imageData = data as? Data
            handlerData(data)
        })
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
