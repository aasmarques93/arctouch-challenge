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
}

extension MovieDetailView: iCarouselDelegate, iCarouselDataSource {
    
    // MARK: - iCarousel delegate and data source -
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if viewModel != nil {
            if carousel == carouselVideos { return viewModel.numberOfVideos }
            return viewModel.numberOfMoviesRecommendations
        }
        return 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if carousel == carouselVideos { return carouselMovieView(at: index) }
        return carouselRecommendationView(at: index)
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
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: height, height: height))
        imageView.backgroundColor = HexColor.primary.color
        imageView.contentMode = .scaleAspectFit
        
        viewModel.movieRecommendationImageData(at: index) { (data) in
            if let data = data as? Data, let image = UIImage(data: data) {
                imageView.image = image
            } else {
                imageView.image = #imageLiteral(resourceName: "searching-movie")
            }
        }
        
        return imageView
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let viewController = instantiateFrom(storyboard: .main, identifier: MovieDetailView.identifier) as! MovieDetailView
        viewController.viewModel = viewModel.movieDetailViewModel(at: index)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
