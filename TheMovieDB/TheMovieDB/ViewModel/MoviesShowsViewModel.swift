//
//  MoviesShowsViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/15/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

protocol MoviesShowsViewModelDelegate: ViewModelDelegate {
    func didReloadLatestBanner()
    func reloadData(at index: Int)
    func openPreview(storiesViewModel: StoriesViewModel)
}

class MoviesShowsViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Observables
    var latestImage = Observable<UIImage>(#imageLiteral(resourceName: "default-image"))
    var latestTitle = Observable<String?>(nil)
    
    // MARK: Delegate
    weak var delegate: MoviesShowsViewModelDelegate?
    
    // MARK: Enum
    var arraySectionsType = [SectionsType]()
    var numberOfSections: Int { return arraySectionsType.count }
    
    // MARK: Service Model
    let moviesServiceModel = MoviesServiceModel()
    let tvShowServiceModel = TVShowServiceModel()
    let netflixServiceModel = NetflixServiceModel()
    let userFriendsServiceModel = UserFriendsServiceModel()
    
    // MARK: Netflix
    var arrayNetflix = [Netflix]() { didSet { delegate?.reloadData?() } }
    var numberOfNetflix: Int { return arrayNetflix.count }
    
    var arrayStoriesPages = [StoriesPageItem]()
    
    // MARK: User Friends
    var arrayUserFriendsMovies = [Movie]()
    var numberOfUserFriendsMovies: Int { return arrayUserFriendsMovies.count }
    
    var arrayUserFriendsShows = [TVShow]()
    var numberOfUserFriendsShows: Int { return arrayUserFriendsShows.count }
    
    // MARK: Variables
    var isDataLoading = false
    var isMovie: Bool
    
    private var dictionaryLastIndexPathsDisplayed = [Int: IndexPath]()
    
    // MARK: - Life cycle -
    
    init(isMovie: Bool = true) {
        self.isMovie = isMovie
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        loadNetflixMoviesShows()
        loadUserFriendsMoviesShows()
    }
    
    func getLatestImage(at path: String?) {
        loadImageData(at: path) { [weak self] (data) in
            guard let data = data as? Data, let image = UIImage(data: data) else {
                return
            }
            self?.latestImage.value = image
            self?.delegate?.didReloadLatestBanner()
        }
    }
    
    func loadImageData(at path: String?, handlerData: @escaping HandlerObject) {
        Singleton.shared.serviceModel.loadImage(path: path, handlerData: handlerData)
    }
    
    // MARK: Netflix
    
    func loadNetflixMoviesShows() {
        guard arrayNetflix.isEmpty else {
            return
        }
        
        guard let userPersonalityType = Singleton.shared.userPersonalityType, let genres = userPersonalityType.netflixGenres else {
            return
        }
        
        genres.forEach { [weak self] (genre) in
            self?.getNetflixMoviesShowsGenres(id: genre)
        }
    }
    
    func getNetflixMoviesShowsGenres(id: Int?) {
        netflixServiceModel.getNetflixMoviesShow(genre: id, isMovie: isMovie) { [weak self] (results) in
            let sortedArray = results.sorted(by: { (movie1, movie2) -> Bool in
                guard let rating1 = movie1.imdbRating, let rating2 = movie2.imdbRating else {
                    return true
                }
                return rating1 > rating2
            })
            self?.arrayNetflix.append(contentsOf: sortedArray)
            self?.reloadData(at: 0)
        }
    }
    
    // MARK: User Friends
    
    func loadUserFriendsMoviesShows() {
        guard arrayUserFriendsMovies.isEmpty || arrayUserFriendsShows.isEmpty  else {
            return
        }
        
        Facebook.getUserFriends { [weak self] (results) in
            self?.getUserFriendsProfiles(with: results)
        }
    }
    
    func getUserFriendsProfiles(with array: [User]) {
        userFriendsServiceModel.userFriendsProfiles(array) { [weak self] (results) in
            self?.arrayUserFriendsMovies = []
            self?.arrayUserFriendsShows = []
            
            results.forEach({ (user) in
                self?.addMoviesShows(user.moviesWantToSeeList)
                self?.addMoviesShows(user.moviesSeenList)
                self?.addMoviesShows(user.showsTrackList)
            })
            
            self?.reloadData(at: SectionsType.friendsWatching.index(isMovie: self?.isMovie ?? true))
        }
    }
    
    // MARK: Movies from genre id
    
    func getMoviesFromGenre(id: Int?, handler: @escaping Handler<SearchMoviesGenre>) {
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
    
    // MARK: - View Model methods -
    
    private func addMoviesShows(_ array: [UserMovieShow]?) {
        guard let array = array else {
            return
        }
        
        array.forEach { (movieShow) in
            if movieShow.movieId != nil {
                let dictionary: [String: Any] = [
                    Movie.SerializationKeys.id: movieShow.movieId ?? 0,
                    Movie.SerializationKeys.posterPath: movieShow.movieImageUrl ?? ""
                ]
                arrayUserFriendsMovies.append(Movie(object: dictionary))
            } else {
                let dictionary: [String: Any] = [
                    TVShow.SerializationKeys.id: movieShow.showId ?? 0,
                    TVShow.SerializationKeys.posterPath: movieShow.showImageUrl ?? 0
                ]
                arrayUserFriendsShows.append(TVShow(object: dictionary))
            }
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
    
    func getRequestUrl(with section: SectionsType) -> RequestUrl? {
        switch section {
        case .nowPlaying:
            return .nowPlaying
        case .upcoming:
            return .upcoming
        case .airingToday:
            return .tvAiringToday
        case .onTheAir:
            return .tvOnTheAir
        case .popular:
            return isMovie ? .popular : .tvPopular
        case .topRated:
            return isMovie ? .topRated : .tvTopRated
        default:
            return nil
        }
    }
    
    func sectionTitle(at section: Int) -> String {
        let sectionType = arraySectionsType[section]
        
        guard sectionType == .suggested,
            let userPersonalityType = Singleton.shared.userPersonalityType,
            let title = userPersonalityType.title else {
                
                return "  \(sectionType.localized)"
        }
        return "  \(sectionType.localized) for \(title)"
    }
    
    // MARK: Stories
    
    func storyPreviewImagePathUrl(at index: Int) -> URL? {
        let netflix = arrayNetflix[index]
        return URL(string: netflixServiceModel.imageUrl(with: netflix.id, isMovie: isMovie))
    }
    
    func storyPreviewTitle(at index: Int) -> String? {
        return arrayNetflix[index].title
    }
    
    // MARK: Videos
    
    func loadVideos(at index: Int) {
        delegate?.openPreview(storiesViewModel: StoriesViewModel(arrayNetflix, selectedIndex: index, isMovie: isMovie))
    }
    
    // MARK: Last indexPath
    
    func setLastIndexPathDisplayed(_ indexPath: IndexPath, at section: Int) {
        dictionaryLastIndexPathsDisplayed[section] = indexPath
    }
    
    func lastIndexPathDisplayed(at section: Int) -> IndexPath? {
        return dictionaryLastIndexPathsDisplayed[section]
    }
    
    // MARK: - View Model instantiation -
    
    func searchResultViewModel(with text: String?) -> SearchResultViewModel? {
        return SearchResultViewModel(searchText: text, requestUrl: isMovie ? .searchMovie : .searchTV)
    }
}

// MARK: - Sections Type -

enum SectionsType: Int {
    case netflix
    case suggested
    case friendsWatching
    case nowPlaying
    case upcoming
    case airingToday
    case onTheAir
    case popular
    case topRated
}

extension SectionsType {
    var description: String {
        switch self {
        case .netflix:
            return "Watch on Netflix"
        case .suggested:
            return "Suggested"
        case .friendsWatching:
            return "What your friends are watching"
        case .nowPlaying:
            return "Now Playing"
        case .upcoming:
            return "Upcoming"
        case .airingToday:
            return "Airing today"
        case .onTheAir:
            return "On the air"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        }
    }
    
    func index(isMovie: Bool) -> Int {
        switch self {
        case .netflix:
            return 0
        case .suggested:
            return 1
        case .friendsWatching:
            return 2
        case .airingToday:
            return 3
        case .popular:
            return isMovie ? 3 : 5
        case .onTheAir:
            return 4
        case .topRated:
            return isMovie ? 4 : 6
        case .upcoming:
            return 5
        case .nowPlaying:
            return 6
        }
    }
    
    var localized: String {
        return NSLocalizedString(self.description, comment: "")
    }
}
