//
//  MovieDetailView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/14/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond
import YouTubePlayer

class MovieDetailView: UITableViewController {
    // MARK: - Outlets -
    
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
    
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var buttonSeen: UIButton!
    @IBOutlet weak var buttonRate: UIButton!
    
    @IBOutlet weak var emojiRateView: EmojiRateView!
    @IBOutlet weak var labelRate: UILabel!
    @IBOutlet weak var labelRateResult: UILabel!
    
    // MARK: - Properties -
    
    private enum DetailRow: Int {
        case buttons = 0
        case rating = 1
        case general = 2
        case genres = 3
        case overview = 4
        case videos = 5
        case recommended = 6
        case cast = 7
        case similiarMovies = 8
        case reviews = 9
    }
    
    private var reviewsView: ReviewsView?
    private var isRatingVisible = false {
        didSet {
            tableView.beginUpdates()
            tableView.reloadData()
            tableView.endUpdates()
        }
    }

    // MARK: - View Model -
    
    var viewModel: MovieDetailViewModel?
        
    // MARK: - Life cycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.delegate = self
        viewModel?.loadData()
        setupBindings()
        setupAppearance()
        reviewsView?.viewModel = viewModel
        
        if let value = viewModel?.movieName {
            FabricUtils.logEvent(message: "\(Messages.didSelect.localized) \(value)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.rateMovie()
    }
    
    // MARK: - View model bindings -
    
    private func setupBindings() {
        viewModel?.average.bind(to: labelAverage.reactive.text)
        viewModel?.date.bind(to: labelDate.reactive.text)
        viewModel?.runtime.bind(to: labelRuntime.reactive.text)
        viewModel?.genres.bind(to: textViewGenres.reactive.text)
        viewModel?.overview.bind(to: textViewOverview.reactive.text)
        viewModel?.rateResult.bind(to: labelRateResult.reactive.text)
        
        if buttonAdd != nil { viewModel?.addImage.bind(to: buttonAdd.reactive.image) }
        if buttonSeen != nil { viewModel?.seenImage.bind(to: buttonSeen.reactive.image) }
    }
    
    // MARK: - Appearance -
    
    private func setupAppearance() {
        title = viewModel?.movieName
        
        carouselVideos.type = .linear
        carouselVideos.bounces = false
        carouselRecommendedMovies.type = .rotary
        carouselCast.type = .rotary
        carouselSimilarMovies.type = .rotary
        
        stretchHeaderView.setupHeaderView(tableView: tableView)
        
        setupRating()
    }
    
    private func setupRating() {
        guard let value = viewModel?.rateValue else {
            return
        }
        
        emojiRateView.rateValue = value
        labelRate.text = "\(value.rounded())"
        labelRate.textColor = emojiRateView.rateColor
        setRateImage(with: value)
    }
    
    private func setRateImage(with value: Float) {
        buttonRate.setImage(value >= 4 ? #imageLiteral(resourceName: "happy-emoji-filled") : value >= 2 ? #imageLiteral(resourceName: "neutral-emoji") : #imageLiteral(resourceName: "sad-emoji"), for: .normal)
    }
    
    // MARK: - Emoji Rate View -
    
    private func setupEmojiRateView() {
        emojiRateView.rateColorRange = (HexColor.accent.color, HexColor.secondary.color)
        emojiRateView.rateValueChangeCallback = { [weak self] (rateValue: Float) -> Void in
            self?.viewModel?.setRateResultValue(rateValue.rounded())
            self?.labelRate.text = "\(rateValue.rounded())"
            self?.setRateImage(with: rateValue)
            guard let color = self?.emojiRateView.rateColor else {
                return
            }
            self?.labelRate.textColor = color
        }
    }
    
    // MARK: - Actions -
    
    @IBAction func buttonAddAction(_ sender: UIButton) {
        viewModel?.toggleAddYourListMovie()
    }
    
    @IBAction func buttonSeenAction(_ sender: UIButton) {
        viewModel?.toggleSeenYourListMovie()
    }
    
    @IBAction func buttonRateAction(_ sender: UIButton) {
        isRatingVisible = !isRatingVisible
        setupEmojiRateView()
    }
    
    // MARK: - Table view data source -
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = super.tableView(tableView, heightForRowAt: indexPath)
        if let row = DetailRow(rawValue: indexPath.row) {
            switch row {
            case .buttons,
                 .general:
                break
            case .rating:
                if !isRatingVisible { height = 0 }
            case .genres:
                height += textViewGenres.contentSize.height
            case .overview:
                height += textViewOverview.contentSize.height
            case .videos:
                if viewModel?.numberOfVideos == 0 { height = 0 }
            case .recommended:
                if viewModel?.numberOfRecommendedMovies == 0 { height = 0 }
            case .cast:
                if viewModel?.numberOfCastCharacters == 0 { height = 0 }
            case .similiarMovies:
                if viewModel?.numberOfSimilarMovies == 0 { height = 0 }
            case .reviews:
                height = (CGFloat(viewModel?.numberOfReviews ?? 0) * (reviewsView?.rowHeight ?? 0)) + 40
                if viewModel?.numberOfReviews == 0 { height = 0 }
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
    
    func showAlert(message: String?) {
        alertController?.show(message: message)
    }
    
    func reloadData() {
        tableView.reloadData()
        
        viewModel?.movieDetailImageData(handlerData: { [weak self] (data) in
            guard let strongSelf = self else {
                return
            }
            
            if let data = data as? Data {
                strongSelf.stretchHeaderView.setupHeaderView(tableView: strongSelf.tableView, image: UIImage(data: data))
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
    
    func reloadSimilarMovies() {
        carouselSimilarMovies.reloadData()
    }
    
    func reloadReviews() {
        reviewsView?.tableView.reloadData()
        tableView.reloadData()
    }
}

extension MovieDetailView: iCarouselDelegate, iCarouselDataSource {
    
    // MARK: - iCarousel delegate and data source -
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if let viewModel = viewModel {
            if carousel == carouselVideos { return viewModel.numberOfVideos }
            if carousel == carouselRecommendedMovies { return viewModel.numberOfRecommendedMovies }
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
        if carousel == carouselCast {
            let viewController = instantiate(viewController: PersonView.self, from: .generic)
            viewController.viewModel = viewModel?.personViewModel(at: index)
            navigationController?.pushViewController(viewController, animated: true)
            return
        }
        if carousel == carouselSimilarMovies {
            let viewController = instantiate(viewController: MovieDetailView.self, from: .movie)
            viewController.viewModel = viewModel?.similarMovieDetailViewModel(at: index)
            navigationController?.pushViewController(viewController, animated: true)
            return
        }
    }
}
