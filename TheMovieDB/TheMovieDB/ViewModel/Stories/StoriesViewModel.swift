//
//  StoriesViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class StoriesViewModel: ViewModel {
    // MARK: Delegate
    weak var delegate: ViewModelDelegate?
    
    // MARK: Service Model
    let netflixServiceModel = NetflixServiceModel()
    
    // MARK: Objects
    private var arrayNetflixMovies: [Netflix]
    
    private var arrayStoriesPages = [StoriesPageItem]()
    var numberOfPages: Int { return arrayStoriesPages.count }
    var selectedIndex: Int = 0
    var currentIndex: Int = 0
    
    // MARK: - Life cycle -
    
    init(_ arrayNetflixMovies: [Netflix], selectedIndex: Int) {
        self.arrayNetflixMovies = arrayNetflixMovies
        self.selectedIndex = selectedIndex
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        arrayNetflixMovies.forEach { [weak self] (object) in
            let url = URL(string: self?.netflixServiceModel.imageUrl(with: object.id) ?? "")
            let storyItems = [StoryItem(content: .video, data: nil)]
            self?.arrayStoriesPages.append(StoriesPageItem(title: object.title, mainImageUrl: url, storyItems: storyItems))
        }
        currentIndex = selectedIndex
        delegate?.reloadData?()
    }
    
    func loadVideo(at index: Int, handler: @escaping HandlerObject) {
        let object = arrayNetflixMovies[index]
        netflixServiceModel.getNetflixDetail(movieShow: object) { (object) in
            guard let object = object as? NetflixMovieShow else {
                return
            }
            handler(object.trailer?.key)
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
}
