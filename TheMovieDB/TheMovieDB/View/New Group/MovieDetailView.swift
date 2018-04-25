//
//  MovieDetailView.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond
import YouTubePlayer

class MovieDetailView: UITableViewController {
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var imageViewPoster: UIImageView!
    
    @IBOutlet weak var labelAverage: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelRuntime: UILabel!
    
    @IBOutlet weak var textViewGenres: UITextView!
    @IBOutlet weak var textViewOverview: UITextView!
    
    @IBOutlet weak var carouselVideos: iCarousel!
    @IBOutlet weak var carouselRecommendedMovies: iCarousel!
    @IBOutlet weak var carouselSimilarMovies: iCarousel!
    
    enum DetailSection: Int {
        case general = 0
        case genres = 1
        case overview = 2
    }
    
    var viewModel: MovieDetailViewModel!
    
    // MARK: - Life cycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppearance()
        setupBindings()
        viewModel.delegate = self
        viewModel.loadData()
    }
    
    // MARK: - Appearance -
    
    func setupAppearance() {
        navigationItem.titleView = nil
        self.title = viewModel.movieName()
        carouselVideos.type = .linear
        carouselVideos.bounces = false
        carouselRecommendedMovies.type = .rotary
        carouselSimilarMovies.type = .rotary
    }
    
    // MARK: - View model bindings -
    
    func setupBindings() {
        viewModel.average.bind(to: labelAverage.reactive.text)
        viewModel.date.bind(to: labelDate.reactive.text)
        viewModel.runtime.bind(to: labelRuntime.reactive.text)
        viewModel.genres.bind(to: textViewGenres.reactive.text)
        viewModel.overview.bind(to: textViewOverview.reactive.text)
    }
    
    // MARK: - Table view data source -
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = super.tableView(tableView, heightForRowAt: indexPath)
        if let section = DetailSection(rawValue: indexPath.row) {
            switch section {
                case .general: break
                case .genres: height += textViewGenres.contentSize.height
                case .overview: height += textViewOverview.contentSize.height
            }
        }
        return height
    }
}

extension MovieDetailView: MovieDetailViewModelDelegate {
    
    // MARK: - Movie detail view model delegate -
    
    func reloadData() {
        tableView.reloadData()
        
        viewModel.imagesData(handlerBackgroundData: { (backgroundData) in
            if let data = backgroundData as? Data { self.imageViewBackground.image = UIImage(data: data) }
        }) { (posterData) in
            if let data = posterData as? Data { self.imageViewPoster.image = UIImage(data: data) }
        }
    }
    
    func reloadVideos() {
        carouselVideos.reloadData()
    }
    
    func reloadRecommendedMovies() {
        carouselRecommendedMovies.reloadData()
    }
    
    func reloadSimilarMovies() {
        carouselSimilarMovies.reloadData()
    }
}

extension MovieDetailView: iCarouselDelegate, iCarouselDataSource {
    
    // MARK: - iCarousel delegate and data source -
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if viewModel != nil {
            if carousel == carouselVideos { return viewModel.numberOfVideos }
            if carousel == carouselRecommendedMovies { return viewModel.numberOfMoviesRecommendations }
            return viewModel.numberOfSimilarMovies
        }
        return 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if carousel == carouselVideos { return carouselMovieView(at: index) }
        if carousel == carouselRecommendedMovies { return carouselRecommendationView(at: index) }
        return carouselSimilarMovieView(at: index)
    }
    
    func carouselMovieView(at index: Int) -> UIView {
        let view = UIView(frame: carouselVideos.frame)
        
        let margin: CGFloat = 8
        
        let labelTitle = UILabel(frame: CGRect(x: margin, y: 0, width: view.frame.width - (margin * 2), height: 20))
        labelTitle.text = viewModel.videoTitle(at: index)
        labelTitle.font = UIFont.boldSystemFont(ofSize: 14)
        labelTitle.textColor = UIColor.white
        labelTitle.textAlignment = .center
        
        view.addSubview(labelTitle)
        
        let videoPlayer = YouTubePlayerView(frame: CGRect(x: margin,
                                                          y: view.frame.minY,
                                                          width: view.frame.width - (margin * 2),
                                                          height: view.frame.height))
        
        if let videoId = viewModel.videoYouTubeId(at: index) { videoPlayer.loadVideoID(videoId) }
        
        view.addSubview(videoPlayer)
        
        return view
    }
    
    func carouselRecommendationView(at index: Int) -> UIView {
        let height: CGFloat = carouselRecommendedMovies.frame.height
        
        let view = UIView(frame: CGRect(x: carouselRecommendedMovies.frame.minX,
                                        y: carouselRecommendedMovies.frame.minY,
                                        width: height,
                                        height: height))
        
        let activityIndicator = createActivityIndicator()
        activityIndicator.center = view.center
        
        let imageView = createMovieImageView(frame: view.frame)
        
        viewModel.movieRecommendationImageData(at: index) { (data) in
            activityIndicator.isHidden = true
            
            if let data = data as? Data, let image = UIImage(data: data) {
                imageView.image = image
            } else {
                imageView.image = #imageLiteral(resourceName: "searching-movie")
            }
        }
        
        view.addSubview(imageView)
        view.addSubview(activityIndicator)
        
        return view
    }
    
    func carouselSimilarMovieView(at index: Int) -> UIView {
        let height: CGFloat = carouselSimilarMovies.frame.height
        
        let view = UIView(frame: CGRect(x: carouselSimilarMovies.frame.minX,
                                        y: carouselSimilarMovies.frame.minY,
                                        width: height,
                                        height: height))
        
        let activityIndicator = createActivityIndicator()
        activityIndicator.center = view.center
        
        let imageView = createMovieImageView(frame: view.frame)
        
        viewModel.similarMovieImageData(at: index) { (data) in
            activityIndicator.isHidden = true
            
            if let data = data as? Data, let image = UIImage(data: data) {
                imageView.image = image
            } else {
                imageView.image = #imageLiteral(resourceName: "searching-movie")
            }
        }
        
        view.addSubview(imageView)
        view.addSubview(activityIndicator)
        
        return view
    }
    
    func createMovieImageView(frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.backgroundColor = HexColor.primary.color
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        return activityIndicator
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let viewController = instantiateFrom(storyboard: .main, identifier: MovieDetailView.identifier) as! MovieDetailView
        if carousel == carouselRecommendedMovies {
            viewController.viewModel = viewModel.recommendedMovieDetailViewModel(at: index)
        } else if carousel == carouselSimilarMovies {
            viewController.viewModel = viewModel.similarMovieDetailViewModel(at: index)
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
