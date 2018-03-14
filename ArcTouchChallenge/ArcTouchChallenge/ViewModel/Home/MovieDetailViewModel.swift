//
//  MovieDetailViewModel.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

protocol MovieDetailViewModelDelegate: class {
    func reloadData()
}

class MovieDetailViewModel: ViewModel {
    weak var delegate: MovieDetailViewModelDelegate?
    
    var name = Observable<String?>(nil)
    var average = Observable<String?>(nil)
    var date = Observable<String?>(nil)
    var runtime = Observable<String?>(nil)
    var genres = Observable<String?>(nil)
    var overview = Observable<String?>(nil)
    
    var object: Movie!
    var movieDetail: MovieDetail? {
        didSet {
            delegate?.reloadData()
            
            if let value = movieDetail?.originalTitle { name.value = value }
            if let value = movieDetail?.releaseDate { date.value = value }
            if let value = movieDetail?.voteAverage { average.value = "\(value)" }
            if let value = movieDetail?.runtime { runtime.value = "\(value) minutes" }
            if let value = movieDetail?.overview { overview.value = value }
            
            genres.value = setupGenres()
        }
    }
    
    init(_ object: Movie) {
        super.init()
        self.object = object
    }
    
    func loadData() {
        if let value = object.id {
            let parameters = ["idMovie": value]
            
            loadingView.startInWindow()
            MovieDetailServiceModel.shared.getMovieDetail(urlParameters: parameters) { (object) in
                self.loadingView.stop()
                self.movieDetail = object as? MovieDetail
            }
        }
    }
    
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
                if let value = genre.name { string += "\(value)" }
                if count < array.count-1 { string += ", " }
                count += 1
            }
        }
        return string
    }
}
