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
    
    // MARK: Service Model
    private let serviceModel = MovieDetailServiceModel()
    private let yourListServiceModel = YourListServiceModel()
    
    // MARK: Observables
    var name = Observable<String?>(nil)
    var average = Observable<String?>(nil)
    var date = Observable<String?>(nil)
    var runtime = Observable<String?>(nil)
    var genres = Observable<String?>(nil)
    var overview = Observable<String?>(nil)
    var rateResult = Observable<String>(Titles.rate.localized)
    
    var addImage = Observable<UIImage>(#imageLiteral(resourceName: "add"))
    var seenImage = Observable<UIImage>(#imageLiteral(resourceName: "seen"))
    
    var rateValue: Float? {
        guard let value = Float(rateResult.value) else {
            return nil
        }
        return value
    }
    
    // MARK: Objects
    private var movie: Movie
    
    private var movieDetail: MovieDetail? {
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
    
    // MARK: Videos
    private var arrayVideos = [Video]() { didSet { delegate?.reloadVideos() } }
    var numberOfVideos: Int { return arrayVideos.count }
    
    // MARK: Recommended
    private var arrayRecommendedMovies = [Movie]() { didSet { delegate?.reloadRecommendedMovies() } }
    var numberOfRecommendedMovies: Int { return arrayRecommendedMovies.count }
    
    // MARK: Similar Movies
    private var arraySimilarMovies = [Movie]() { didSet { delegate?.reloadSimilarMovies() } }
    var numberOfSimilarMovies: Int { return arraySimilarMovies.count }
    
    // MARK: Cast
    private var arrayCast = [Cast]() { didSet { delegate?.reloadCast() } }
    var numberOfCastCharacters: Int { return arrayCast.count }
    
    // MARK: Reviews
    private var arrayReviews = [Review]() { didSet { delegate?.reloadReviews() } }
    var numberOfReviews: Int { return arrayReviews.count }
    
    var isMovieInYourWantToSeeList: Bool {
        return Singleton.shared.isMovieInYourWantToSeeList(movie: movie)
    }
    
    var isMovieInYourSeenList: Bool {
        return Singleton.shared.isMovieInYourSeenList(movie: movie)
    }
    
    // MARK: - Life cycle -
    
    init(_ object: Movie) {
        self.movie = object
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        setupImages()
        setupRating()
        getMovieDetail()
        getVideos()
        getRecommendedMovies()
        getSimilarMovies()
        getCredits()
        getReviews()
    }
    
    private func getMovieDetail() {
        Loading.shared.start()
        serviceModel.getDetail(from: movie) { [weak self] (object) in
            Loading.shared.stop()
            self?.movieDetail = object
        }
    }
    
    private func getVideos() {
        guard arrayVideos.isEmpty else {
            return
        }
        
        serviceModel.getVideos(from: movie) { [weak self] (object) in
            guard let results = object.results else {
                return
            }
            
            self?.arrayVideos.append(contentsOf: results)
        }
    }
    
    private func getRecommendedMovies() {
        guard arrayRecommendedMovies.isEmpty else {
            return
        }
        
        serviceModel.getRecommendations(from: movie) { [weak self] (object) in
            guard let results = object.results else {
                return
            }
            
            self?.arrayRecommendedMovies.append(contentsOf: results)
        }
    }
    
    private func getSimilarMovies() {
        guard arraySimilarMovies.isEmpty else {
            return
        }
        
        serviceModel.getSimilar(from: movie) { [weak self] (object) in
            guard let results = object.results else {
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
            guard let results = object.cast else {
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
            guard let results = object.results else {
                return
            }
            
            self?.arrayReviews.append(contentsOf: results)
        }
    }
    
    func rateMovie() {
        guard let value = rateValue else {
            return
        }
        serviceModel.rate(movie: movie, value: value) { (object) in
            Singleton.shared.loadUserData()
        }
    }
    
    // MARK: - View Model -
    
    // MARK: Appearance
    
    private func setupImages() {
        addImage.value = isMovieInYourWantToSeeList ? #imageLiteral(resourceName: "add-filled") : #imageLiteral(resourceName: "add")
        seenImage.value = isMovieInYourSeenList ? #imageLiteral(resourceName: "seen-filled") : #imageLiteral(resourceName: "seen")
    }
    
    private func setupRating() {
        let ratings = Singleton.shared.arrayUserRatings.filter { $0.movieId == movie.id }
        guard let userRating = ratings.first, let rate = userRating.rate else {
            return
        }
        rateResult.value = "\(rate)"
    }
    
    // MARK: Rating
    
    func setRateResultValue(_ value: Float) {
        rateResult.value = "\(value)"
    }
    
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
            let arrayNames = array.map { valueDescription($0.name) }
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
    
    func movieRecommendationImageUrl(at index: Int) -> URL? {
        let movie = arrayRecommendedMovies[index]
        return URL(string: serviceModel.imageUrl(with: movie.posterPath ?? ""))
    }
    
    // MARK: Similar
    
    func similarMovieImageUrl(at index: Int) -> URL? {
        let movie = arraySimilarMovies[index]
        return URL(string: serviceModel.imageUrl(with: movie.posterPath ?? ""))
    }
    
    // MARK: Cast
    
    func castImageUrl(at index: Int) -> URL? {
        let cast = arrayCast[index]
        return URL(string: serviceModel.imageUrl(with: cast.profilePath ?? ""))
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
    
    // MARK: - Your List -
    
    func toggleAddYourListMovie() {
        guard isMovieInYourWantToSeeList else {
            addImage.value = #imageLiteral(resourceName: "add-filled")
            
            if isMovieInYourSeenList {
                seenImage.value = #imageLiteral(resourceName: "seen")
                deleteFromYourSeenList()
            }
            
            saveToYourWantToSeeList()
            return
        }
        addImage.value = #imageLiteral(resourceName: "add")
        deleteFromYourWantToSeeList()
    }
    
    private func saveToYourWantToSeeList() {
        yourListServiceModel.save(movie: movie, requestUrl: .saveWantToSeeMovie)
        Singleton.shared.loadUserData()
    }
    
    private func deleteFromYourWantToSeeList() {
        yourListServiceModel.delete(movie: movie, requestUrl: .deleteWantToSeeMovie)
        Singleton.shared.loadUserData()
    }
    
    func toggleSeenYourListMovie() {
        guard isMovieInYourSeenList else {
            seenImage.value = #imageLiteral(resourceName: "seen-filled")
            
            if isMovieInYourWantToSeeList {
                addImage.value = #imageLiteral(resourceName: "add")
                deleteFromYourWantToSeeList()
            }
            
            saveToYourSeenList()
            return
        }
        seenImage.value = #imageLiteral(resourceName: "seen")
        deleteFromYourSeenList()
    }
    
    private func saveToYourSeenList() {
        yourListServiceModel.save(movie: movie, requestUrl: .saveSeenMovie)
        Singleton.shared.loadUserData()
    }
    
    private func deleteFromYourSeenList() {
        yourListServiceModel.delete(movie: movie, requestUrl: .deleteSeenMovie)
        Singleton.shared.loadUserData()
    }
    
    // MARK: - View Model Instantiation -
    
    func recommendedMovieDetailViewModel(at index: Int) -> MovieDetailViewModel? {
        return movieDetailViewModel(arrayRecommendedMovies[index])
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
