//
//  MoviesView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond
import XCDYouTubeKit
import AVFoundation
import AVKit

class MoviesView: UITableViewController {
    @IBOutlet weak var carouselPreviews: iCarousel!
    
    let searchHeaderView = SearchHeaderView.instantateFromNib(title: Titles.moviesPreview.localized,
                                                              placeholder: Messages.searchMovie.localized)
    let viewHeaderHeight: CGFloat = 32
    
    let viewModel = MoviesViewModel()
    
    var labelHeader: UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: viewHeaderHeight))
        label.backgroundColor = HexColor.primary.color
        label.textColor = HexColor.text.color
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        StoreReviewHelper.checkAndAskForReview()
        Singleton.shared.didSkipTestFromLauching = true
        searchHeaderView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        viewModel.delegate = self
        viewModel.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.shared.unlockOrientation()
    }
    
    func setupAppearance() {
        carouselPreviews.type = .linear
        
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0,
                                              width: SCREEN_WIDTH,
                                              height: searchHeaderView.frame.height + carouselPreviews.frame.height))
        viewHeader.backgroundColor = HexColor.primary.color
        carouselPreviews.frame = CGRect(x: viewHeader.frame.minX,
                                        y: searchHeaderView.frame.maxY,
                                        width: carouselPreviews.frame.width,
                                        height: carouselPreviews.frame.height)
        
        viewHeader.addSubview(searchHeaderView)
        viewHeader.addSubview(carouselPreviews)
        
        tableView.tableHeaderView = viewHeader
    }
    
    // MARK: - Table view data source -
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfGenres
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = labelHeader
        label.text = viewModel.genreTitle(at: section)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.isMoviesEmpty(at: indexPath) { return 44 }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MoviesSectionViewCell.self, for: indexPath)
        cell.viewModel = viewModel
        cell.setupView(at: indexPath)
        cell.delegate = self
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        searchHeaderView.frame = CGRect(x: searchHeaderView.frame.minX,
                                        y: searchHeaderView.frame.minY,
                                        width: size.width,
                                        height: searchHeaderView.frame.height)
        tableView.reloadData()
    }
}

extension MoviesView: SearchHeaderViewDelegate {
    
    // MARK: - Search bar delegate -
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmptyOrWhitespace {
            let viewController = instantiate(viewController: SearchResultView.self, from: .search)
            viewController.viewModel = viewModel.searchResultViewModel(with: searchBar.text)
            navigationController?.pushViewController(viewController, animated: true)
        }
        searchBar.text = nil
    }
}

extension MoviesView: MoviesViewCellDelegate {
    
    // MARK: - Movies view cell delegate -
    
    func didSelectItem(at section: Int, row: Int) {
        let viewController = instantiate(viewController: MovieDetailView.self, from: .movie)
        viewController.viewModel = viewModel.movieDetailViewModel(at: section, row: row)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MoviesView: MoviesViewModelDelegate {
    
    // MARK: - Movies view model delegate -
    
    func reloadData() {
        carouselPreviews.reloadData()
    }
    
    func reloadData(at index: Int) {
        let indexPath = IndexPath(row: 0, section: index)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showError(message: String?) {
        AlertController.show(message: message)
    }
    
    func openVideo(youtubeId: String) {
        let viewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: youtubeId)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerPlaybackDidFinish),
                                               name: NSNotification.Name.AVPlayerItemTimeJumped,
                                               object: nil)
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromTop
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func playerPlaybackDidFinish() {
        print("Did finish")
    }
}

extension MoviesView: iCarouselDelegate, iCarouselDataSource {
    
    // MARK: - iCarousel delegate and data source -
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return viewModel.numberOfSugestedMovies
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        return carouselPreviewView(at: index)
    }
    
    func carouselPreviewView(at index: Int) -> UIView {
        let view = XibView.instanceFromNib(MoviePreviewView.self)
        
        if let url = viewModel.moviePreviewImagePathUrl(at: index) {
            view.imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "default-image"), options: [], completed: nil)
        }

        return view
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if carousel == carouselPreviews {
            viewModel.loadVideos(at: index)
        }
    }
}
