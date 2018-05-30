//
//  StoriesViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

class StoriesViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: ViewModelDelegate?
    
    // MARK: Service Model
    private let netflixServiceModel = NetflixServiceModel()
    
    // MARK: Objects
    private var arrayNetflixMovies: [Netflix]
    var selectedIndex: Int
    private var isMovie: Bool
    
    private var arrayStoriesPages = [StoriesPageItem]()
    
    // MARK: Variables
    var numberOfPages: Int { return arrayStoriesPages.count }
    var currentIndex: Int = 0
    private var currentNetflixMovieShow: NetflixMovieShow?
    
    // MARK: - Life cycle -
    
    init(_ arrayNetflixMovies: [Netflix], selectedIndex: Int, isMovie: Bool = true) {
        self.arrayNetflixMovies = arrayNetflixMovies
        self.selectedIndex = selectedIndex
        self.isMovie = isMovie
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        arrayNetflixMovies.forEach { [weak self] (object) in
            let url = URL(string: self?.netflixServiceModel.imageUrl(with: object.id, isMovie: isMovie) ?? "")
            let storyItems = [StoryItem(content: .video, data: nil)]
            self?.arrayStoriesPages.append(StoriesPageItem(title: object.title, mainImageUrl: url, storyItems: storyItems))
        }
        currentIndex = selectedIndex
        delegate?.reloadData?()
    }
    
    func loadVideo(at index: Int, handler: @escaping Handler<String>) {
        let object = arrayNetflixMovies[index]
        netflixServiceModel.getNetflixDetail(movieShow: object, isMovie: isMovie) { [weak self] (object) in
            self?.currentNetflixMovieShow = object
            handler(object.trailer?.key ?? "")
        }
    }
    
    // MARK: - View Model -
    
    func isItemAvailable(at index: Int?) -> Bool {
        guard let index = index else {
            return false
        }
        return arrayStoriesPages.count > 0 && index < arrayStoriesPages.count
    }
    
    func isStoryItemAvailable(at index: Int?) -> Bool {
        guard let index = index else {
            return false
        }
        return index < currentStoryItems(at: index).count
    }
    
    func setCurrentIndex(_ index: Int?) {
        guard let index = index else {
            return
        }
        currentIndex = index
    }
    
    func currentStoryItems(at index: Int?) -> [StoryItem] {
        guard let index = index, isItemAvailable(at: index) else {
            return []
        }
        return arrayStoriesPages[index].storyItems
    }
    
    func mainUrlImage(at index: Int) -> URL? {
        guard isItemAvailable(at: index) else {
            return nil
        }
        return arrayStoriesPages[index].mainImageUrl
    }
    
    func title(at index: Int) -> String? {
        guard isItemAvailable(at: index) else {
            return nil
        }
        return arrayStoriesPages[index].title
    }
    
    func netflixId(at index: Int) -> String? {
        guard let availability = currentNetflixMovieShow?.availability, let item = availability.first else {
            return nil
        }
        return item.sourceData?.references?.ios?.movieId
    }
}
