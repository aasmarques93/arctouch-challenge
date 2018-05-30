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

protocol SectionsTypeProtocol {
    static var sectionsMovies: [Self] { get }
    static var sectionsShows: [Self] { get }
}

enum SectionsType: Int, SectionsTypeProtocol {
    static var sectionsMovies: [SectionsType] {
        return [
            SectionsType.netflix,
            SectionsType.Suggested,
            SectionsType.friendsWatching,
            SectionsType.nowPlaying,
            SectionsType.topRated,
            SectionsType.upcoming,
            SectionsType.popular
        ]
    }
    
    static var sectionsShows: [SectionsType] {
        return [
            SectionsType.netflix,
            SectionsType.Suggested,
            SectionsType.friendsWatching,
            SectionsType.airingToday,
            SectionsType.onTheAir,
            SectionsType.popular,
            SectionsType.topRated
        ]
    }
    
    case netflix
    case Suggested
    case friendsWatching
    case nowPlaying
    case upcoming
    case airingToday
    case onTheAir
    case popular
    case topRated
    
    static func sections(isMovie: Bool) -> [SectionsType] {
        guard isMovie else {
            return sectionsShows
        }
        return sectionsMovies
    }
    
    var description: String {
        switch self {
        case .netflix:
            return "Watch on Netflix"
        case .Suggested:
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
        case .Suggested:
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
    
    static func section(at index: Int, isMovie: Bool) -> SectionsType? {
        switch index {
        case 0:
            return SectionsType.netflix
        case 1:
            return SectionsType.Suggested
        case 2:
            return SectionsType.friendsWatching
        case 3:
            return isMovie ? SectionsType.popular : SectionsType.airingToday
        case 4:
            return isMovie ? SectionsType.topRated : SectionsType.onTheAir
        case 5:
            return isMovie ? SectionsType.upcoming : SectionsType.popular
        case 6:
            return isMovie ? SectionsType.nowPlaying : SectionsType.topRated
        default:
            return nil
        }
    }
    
    var localized: String {
        return NSLocalizedString(self.description, comment: "")
    }
}

class MoviesShowsViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Observables
    var latestImage = Observable<UIImage>(#imageLiteral(resourceName: "default-image"))
    var latestTitle = Observable<String?>(nil)
    
    // MARK: Delegate
    weak var delegate: MoviesShowsViewModelDelegate?
    
    // MARK: Enum
    private var arraySectionsType: [SectionsType]
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
    
    init(isMovie: Bool = true) {
        self.isMovie = isMovie
        arraySectionsType = SectionsType.sections(isMovie: isMovie)
    }
    
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
    
    func loadUserFriendsMoviesShows() {
        guard arrayUserFriendsMovies.isEmpty || arrayUserFriendsShows.isEmpty  else {
            return
        }
        
        Facebook.getUserFriends { [weak self] (object) in
            guard let array = object as? [User] else {
                return
            }
            
            self?.getUserFriendsProfiles(with: array)
        }
    }
    
    func getUserFriendsProfiles(with array: [User]) {
        userFriendsServiceModel.userFriendsProfiles(array) { [weak self] (object) in
            guard let result = object as? [User] else {
                return
            }
            
            self?.arrayUserFriendsMovies = []
            self?.arrayUserFriendsShows = []
            
            result.forEach({ (user) in
                self?.addMoviesShows(user.moviesWantToSeeList)
                self?.addMoviesShows(user.moviesSeenList)
                self?.addMoviesShows(user.showsTrackList)
            })
            
            self?.reloadData(at: SectionsType.friendsWatching.index(isMovie: self?.isMovie ?? true))
        }
    }
    
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
        guard let sectionType = SectionsType.section(at: section, isMovie: isMovie) else {
            return ""
        }
        guard sectionType == .Suggested,
            let userPersonalityType = Singleton.shared.userPersonalityType,
            let title = userPersonalityType.title else {
                
                return "  \(sectionType.localized)"
        }
        return "  \(sectionType.localized) for \(title)"
    }
    
    func storyPreviewImagePathUrl(at index: Int) -> URL? {
        let netflix = arrayNetflix[index]
        return URL(string: netflixServiceModel.imageUrl(with: netflix.id, isMovie: isMovie))
    }
    
    func storyPreviewTitle(at index: Int) -> String? {
        return arrayNetflix[index].title
    }
    
    func loadVideos(at index: Int) {
        delegate?.openPreview(storiesViewModel: StoriesViewModel(arrayNetflix, selectedIndex: index, isMovie: isMovie))
    }
    
    func setLastIndexPathDisplayed(_ indexPath: IndexPath, at section: Int) {
        dictionaryLastIndexPathsDisplayed[section] = indexPath
    }
    
    func lastIndexPathDisplayed(at section: Int) -> IndexPath? {
        return dictionaryLastIndexPathsDisplayed[section]
    }
    
    func searchResultViewModel(with text: String?) -> SearchResultViewModel? {
        return SearchResultViewModel(searchText: text, requestUrl: isMovie ? .searchMovie : .searchTV)
    }
}
