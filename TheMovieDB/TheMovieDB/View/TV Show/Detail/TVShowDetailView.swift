//
//  TVShowDetailView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class TVShowDetailView: UITableViewController {
    // MARK: - Outlets -
    
    @IBOutlet weak var circularProgressView: CircularProgressView!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var textViewGenres: UITextView!
    @IBOutlet weak var textViewOverview: UITextView!
    
    @IBOutlet weak var carouselVideos: iCarousel!
    @IBOutlet weak var carouselSeasons: iCarousel!
    @IBOutlet weak var carouselRecommended: iCarousel!
    @IBOutlet weak var carouselCast: iCarousel!
    @IBOutlet weak var carouselSimilar: iCarousel!
    
    @IBOutlet weak var buttonRate: UIButton!
    @IBOutlet weak var labelRateResult: UILabel!
    @IBOutlet weak var labelRate: UILabel!
    @IBOutlet weak var emojiRateView: EmojiRateView!
    
    @IBOutlet var stretchHeaderView: StretchHeaderView!
    
    // MARK: - Properties -
    
    private enum DetailSection: Int {
        case general = 0
        case rating = 1
        case genres = 2
        case overview = 3
        case videos = 4
        case seasons = 5
        case recommended = 6
        case cast = 7
        case similar = 8
    }
    
    private var isRatingVisible = false {
        didSet {
            tableView.beginUpdates()
            tableView.reloadData()
            tableView.endUpdates()
        }
    }

    // MARK: - View Model -
    
    var viewModel: TVShowDetailViewModel?
    
    // MARK: - Life cycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.delegate = self
        viewModel?.loadData()
        setupBindings()
        setupAppearance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.rateShow()
    }
    
    // MARK: - View model bindings -
    
    private func setupBindings() {
        viewModel?.date.bind(to: labelDate.reactive.text)
        viewModel?.genres.bind(to: textViewGenres.reactive.text)
        viewModel?.overview.bind(to: textViewOverview.reactive.text)
        viewModel?.rateResult.bind(to: labelRateResult.reactive.text)
    }
    
    // MARK - Appearance -
    
    private func setupAppearance() {
        carouselVideos.type = .linear
        carouselVideos.bounces = false
        carouselSeasons.type = .linear
        carouselSeasons.bounces = false
        carouselRecommended.type = .rotary
        carouselCast.type = .rotary
        carouselSimilar.type = .rotary
        
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
    
    @IBAction func buttonRateAction(_ sender: UIButton) {
        isRatingVisible = !isRatingVisible
        setupEmojiRateView()
    }
    
    @IBAction func buttonTrackAction(_ sender: UIButton) {
        let viewController = instantiate(viewController: TrackView.self, from: .tvShow)
        viewController.viewModel = viewModel?.trackViewModel()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Table view data source -
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = super.tableView(tableView, heightForRowAt: indexPath)
        if let section = DetailSection(rawValue: indexPath.row) {
            switch section {
            case .general:
                break
            case .rating:
                if !isRatingVisible { height = 0 }
            case .genres:
                height += textViewGenres.contentSize.height
            case .overview:
                height += textViewOverview.contentSize.height
            case .videos:
                if viewModel?.numberOfVideos == 0 { height = 0 }
            case .seasons:
                if viewModel?.numberOfSeasons == 0 { height = 0 }
            case .recommended:
                if viewModel?.numberOfRecommended == 0 { height = 0 }
            case .cast:
                if viewModel?.numberOfCastCharacters == 0 { height = 0 }
            case .similar:
                if viewModel?.numberOfSimilar == 0 { height = 0 }
            }
        }
        return height
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            stretchHeaderView.scrollViewDidScroll(scrollView)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        stretchHeaderView.deviceOrientationDidRotate(to: size)
    }
}

extension TVShowDetailView: TVShowDetailViewModelDelegate {
    
    // MARK: - TV show detail view model delegate -
    
    func reloadData() {
        tableView.reloadData()
        
        title = viewModel?.tvShowName
        
        if let value = viewModel?.tvShowName {
            FabricUtils.logEvent(message: "\(Messages.didSelect.localized) \(value)")
        }
        
        if let average = viewModel?.average { circularProgressView.progress = average }
        
        viewModel?.tvShowDetailImageData(handlerData: { [weak self] (data) in
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
    
    func reloadSeasons() {
        carouselSeasons.reloadData()
    }
    
    func reloadRecommended() {
        carouselRecommended.reloadData()
    }
    
    func reloadSimilar() {
        carouselSimilar.reloadData()
    }
    
    func reloadCast() {
        carouselCast.reloadData()
    }
}

extension TVShowDetailView: iCarouselDelegate, iCarouselDataSource {
    
    // MARK: - iCarousel delegate and data source -
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if let viewModel = viewModel {
            if carousel == carouselVideos { return viewModel.numberOfVideos }
            if carousel == carouselSeasons { return viewModel.numberOfSeasons }
            if carousel == carouselRecommended { return viewModel.numberOfRecommended }
            if carousel == carouselCast { return viewModel.numberOfCastCharacters }
            return viewModel.numberOfSimilar
        }
        return 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if carousel == carouselVideos { return carouselVideoView(at: index) }
        if carousel == carouselSeasons { return carouselSeasonView(at: index) }
        if carousel == carouselRecommended { return carouselRecommendationView(at: index) }
        if carousel == carouselCast { return carouselCastView(at: index) }
        return carouselSimilarView(at: index)
    }
    
    func carouselVideoView(at index: Int) -> UIView {
        let view = XibView.instanceFromNib(PlayerView.self)
        
        view.labelVideo.text = viewModel?.videoTitle(at: index)
        
        DispatchQueue.main.async {
            if let videoId = self.viewModel?.videoYouTubeId(at: index) { view.playerView.loadVideoID(videoId) }
        }
        
        return view
    }
    
    func carouselSeasonView(at index: Int) -> UIView {
        let view = XibView.instanceFromNib(SeasonView.self)
        let margin: CGFloat = 4
        view.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: SCREEN_WIDTH - (margin * 2), height: view.frame.height)
        
        view.labelName.text = viewModel?.seasonName(at: index)
        view.labelYear.text = viewModel?.seasonYear(at: index)
        view.labelEpisodeCount.text = viewModel?.seasonEpisodeCount(at: index)
        view.textViewOverview.text = viewModel?.seasonOverview(at: index)
        
        viewModel?.seasonImageData(at: index, handlerData: { (data) in
            if let data = data as? Data, let image = UIImage(data: data) {
                view.imageViewPhoto.image = image
            }
        })
        
        return view
    }
    
    func carouselRecommendationView(at index: Int) -> UIView {
        let view = XibView.instanceFromNib(MovieView.self)
        
        viewModel?.recommendedImageData(at: index) { (data) in
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
    
    func carouselSimilarView(at index: Int) -> UIView {
        let view = XibView.instanceFromNib(MovieView.self)
        
        viewModel?.similarImageData(at: index) { (data) in
            if let data = data as? Data, let image = UIImage(data: data) {
                view.imageViewMovie.image = image
            }
        }
        
        return view
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if carousel == carouselSeasons {
            let viewController = instantiate(viewController: SeasonDetailView.self, from: .tvShow)
            viewController.viewModel = viewModel?.seasonDetailViewModel(at: index)
            navigationController?.pushViewController(viewController, animated: true)
            return
        }
        if carousel == carouselRecommended {
            let viewController = instantiate(viewController: TVShowDetailView.self, from: .tvShow)
            viewController.viewModel = viewModel?.recommendedDetailViewModel(at: index)
            navigationController?.pushViewController(viewController, animated: true)
            return
        }
        if carousel == carouselCast {
            let viewController = instantiate(viewController: PersonView.self, from: .generic)
            viewController.viewModel = viewModel?.personViewModel(at: index)
            navigationController?.pushViewController(viewController, animated: true)
            return
        }
        if carousel == carouselSimilar {
            let viewController = instantiate(viewController: TVShowDetailView.self, from: .tvShow)
            viewController.viewModel = viewModel?.similarDetailViewModel(at: index)
            navigationController?.pushViewController(viewController, animated: true)
            return
        }
    }
}
