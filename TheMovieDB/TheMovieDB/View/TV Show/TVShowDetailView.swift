//
//  TVShowDetailView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class TVShowDetailView: UITableViewController {
    @IBOutlet weak var circularProgressView: CircularProgressView!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var textViewGenres: UITextView!
    @IBOutlet weak var textViewOverview: UITextView!
    
    @IBOutlet weak var carouselVideos: iCarousel!
    @IBOutlet weak var carouselSeasons: iCarousel!
    @IBOutlet weak var carouselCast: iCarousel!
    
    @IBOutlet var stretchHeaderView: StretchHeaderView!
    
    enum DetailSection: Int {
        case general = 0
        case genres = 1
        case overview = 2
        case videos = 3
        case seasons = 4
        case cast = 6
    }
    
    var viewModel: TVShowDetailViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppearance()
        setupBindings()
        viewModel?.delegate = self
        viewModel?.loadData()
    }
    
    func setupAppearance() {
        carouselVideos.type = .linear
        carouselVideos.bounces = false
        carouselSeasons.type = .linear
        carouselSeasons.bounces = false
        carouselCast.type = .rotary
        
        stretchHeaderView.setupHeaderView(tableView: tableView)
    }
    
    // MARK: - View model bindings -
    
    func setupBindings() {
        viewModel?.date.bind(to: labelDate.reactive.text)
        viewModel?.genres.bind(to: textViewGenres.reactive.text)
        viewModel?.overview.bind(to: textViewOverview.reactive.text)
    }
    
    // MARK: - Table view data source -
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = super.tableView(tableView, heightForRowAt: indexPath)
        if let section = DetailSection(rawValue: indexPath.row) {
            switch section {
            case .general:
                break
            case .videos:
                if viewModel?.numberOfVideos == 0 { height = 0 }
            case .seasons:
                if viewModel?.numberOfSeasons == 0 { height = 0 }
            case .cast:
                if viewModel?.numberOfCastCharacters == 0 { height = 0 }
            case .genres:
                height += textViewGenres.contentSize.height
            case .overview:
                height += textViewOverview.contentSize.height
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
        
        setTitle(text: viewModel?.tvShowName)
        
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
            if carousel == carouselCast { return viewModel.numberOfCastCharacters }
        }
        return 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if carousel == carouselVideos { return carouselVideoView(at: index) }
        if carousel == carouselSeasons { return carouselSeasonView(at: index) }
        if carousel == carouselCast { return carouselCastView(at: index) }
        return UIView()
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
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if carousel == carouselCast {
            let viewController = instantiate(viewController: PersonView.self, from: .generic)
            viewController.viewModel = viewModel?.personViewModel(at: index)
            navigationController?.pushViewController(viewController, animated: true)
        } else if carousel == carouselSeasons {
            let viewController = instantiate(viewController: SeasonDetailView.self, from: .tvShow)
            viewController.viewModel = viewModel?.seasonDetailViewModel(at: index)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
