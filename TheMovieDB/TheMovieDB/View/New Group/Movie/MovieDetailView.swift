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
    @IBOutlet weak var labelAverage: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelRuntime: UILabel!
    
    @IBOutlet weak var textViewGenres: UITextView!
    @IBOutlet weak var textViewOverview: UITextView!
    
    @IBOutlet weak var carouselVideos: iCarousel!
    @IBOutlet weak var carouselRecommendedMovies: iCarousel!
    @IBOutlet weak var carouselCast: iCarousel!
    @IBOutlet weak var carouselSimilarMovies: iCarousel!
    
    @IBOutlet var stretchHeaderView: StretchHeaderView!
    
    enum DetailSection: Int {
        case general = 0
        case genres = 1
        case overview = 2
        case reviews = 7
    }
    
    var reviewsView: ReviewsView?
    var viewModel: MovieDetailViewModel?
    
    // MARK: - Life cycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppearance()
        setupBindings()
        viewModel?.delegate = self
        viewModel?.loadData()
        reviewsView?.viewModel = viewModel
    }
    
    // MARK: - Appearance -
    
    func setupAppearance() {
        navigationItem.titleView = nil
        title = viewModel?.movieName
        
        carouselVideos.type = .linear
        carouselVideos.bounces = false
        carouselRecommendedMovies.type = .rotary
        carouselCast.type = .rotary
        carouselSimilarMovies.type = .rotary
        
        stretchHeaderView.setupHeaderView(tableView: tableView)
    }
    
    // MARK: - View model bindings -
    
    func setupBindings() {
        viewModel?.average.bind(to: labelAverage.reactive.text)
        viewModel?.date.bind(to: labelDate.reactive.text)
        viewModel?.runtime.bind(to: labelRuntime.reactive.text)
        viewModel?.genres.bind(to: textViewGenres.reactive.text)
        viewModel?.overview.bind(to: textViewOverview.reactive.text)
    }
    
    // MARK: - Table view data source -
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = super.tableView(tableView, heightForRowAt: indexPath)
        if let section = DetailSection(rawValue: indexPath.row) {
            switch section {
            case .general: break
            case .genres:
                height += textViewGenres.contentSize.height
            case .overview:
                height += textViewOverview.contentSize.height
            case .reviews:
                height = (CGFloat(viewModel?.numberOfReviews ?? 0) * (reviewsView?.rowHeight ?? 0)) + 40
            }
        }
        return height
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            stretchHeaderView.scrollViewDidScroll(scrollView)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ReviewsView {
            reviewsView = viewController
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        stretchHeaderView.deviceOrientationDidRotate(to: size)
    }
}

extension MovieDetailView: MovieDetailViewModelDelegate {
    
    // MARK: - Movie detail view model delegate -
    
    func reloadData() {
        tableView.reloadData()
        
        viewModel?.movieDetailImageData(handlerData: { (data) in
            if let data = data as? Data {
                self.stretchHeaderView.setupHeaderView(tableView: self.tableView, image: UIImage(data: data))
            }
        })
    }
    
    func reloadVideos() {
        carouselVideos.reloadData()
    }
    
    func reloadRecommendedMovies() {
        carouselRecommendedMovies.reloadData()
    }
    
    func reloadCast() {
        carouselCast.reloadData()
    }
    
    func reloadReviews() {
        reviewsView?.tableView.reloadData()
        tableView.reloadData()
    }
    
    func reloadSimilarMovies() {
        carouselSimilarMovies.reloadData()
    }
}

extension MovieDetailView: iCarouselDelegate, iCarouselDataSource {
    
    // MARK: - iCarousel delegate and data source -
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if let viewModel = viewModel {
            if carousel == carouselVideos { return viewModel.numberOfVideos }
            if carousel == carouselRecommendedMovies { return viewModel.numberOfMoviesRecommendations }
            if carousel == carouselCast { return viewModel.numberOfCastCharacters }
            return viewModel.numberOfSimilarMovies
        }
        return 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if carousel == carouselVideos { return carouselMovieView(at: index) }
        if carousel == carouselRecommendedMovies { return carouselRecommendationView(at: index) }
        if carousel == carouselCast { return carouselCastView(at: index) }
        return carouselSimilarMovieView(at: index)
    }
    
    func carouselMovieView(at index: Int) -> UIView {
        let view = XibView.instanceFromNib(PlayerView.self)
        
        view.labelVideo.text = viewModel?.videoTitle(at: index)
        
        DispatchQueue.main.async {
            if let videoId = self.viewModel?.videoYouTubeId(at: index) { view.playerView.loadVideoID(videoId) }
        }
        
        return view
    }
    
    func carouselRecommendationView(at index: Int) -> UIView {
        let view = XibView.instanceFromNib(MovieView.self)
        
        viewModel?.movieRecommendationImageData(at: index) { (data) in
            if let data = data as? Data, let image = UIImage(data: data) {
                view.imageViewMovie.image = image
            }
        }
        
        return view
    }
    
    func carouselCastView(at index: Int) -> UIView {
        let view = XibView.instanceFromNib(CastView.self)
        
        viewModel?.castImageData(at: index) { (data) in
            if let data = data as? Data, let image = UIImage(data: data) {
                view.imageViewCharacter.image = image
            }
        }
        
        view.labelCharacter.text = viewModel?.castCharacter(at: index)
        view.labelName.text = viewModel?.castName(at: index)
        
        return view
    }
    
    func carouselSimilarMovieView(at index: Int) -> UIView {
        let view = XibView.instanceFromNib(MovieView.self)
        
        viewModel?.similarMovieImageData(at: index) { (data) in
            if let data = data as? Data, let image = UIImage(data: data) {
                view.imageViewMovie.image = image
            }
        }
        
        return view
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if carousel == carouselRecommendedMovies {
            let viewController = instantiate(viewController: MovieDetailView.self, from: .movie)
            viewController.viewModel = viewModel?.recommendedMovieDetailViewModel(at: index)
            navigationController?.pushViewController(viewController, animated: true)
            return
        }
        if carousel == carouselSimilarMovies {
            let viewController = instantiate(viewController: MovieDetailView.self, from: .movie)
            viewController.viewModel = viewModel?.similarMovieDetailViewModel(at: index)
            navigationController?.pushViewController(viewController, animated: true)
            return
        }
        if carousel == carouselCast {
            let viewController = instantiate(viewController: PersonView.self, from: .generic)
            viewController.viewModel = viewModel?.personViewModel(at: index)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
