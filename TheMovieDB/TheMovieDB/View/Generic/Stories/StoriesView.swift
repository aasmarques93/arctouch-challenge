//
//  StoriesView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import XCDYouTubeKit

struct StoriesPageItem {
    var title: String?
    var mainImageUrl: URL?
    var storyItems = [StoryItem]()
}

enum StoryContentType {
    case image
    case video
}

struct StoryItem {
    var content: StoryContentType
    var data: Any?
}

class StoriesView: UIViewController {
    // MARK: - Outlets -
    
    @IBOutlet weak var imageViewHeader: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonNetflix: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties -
    
    var pageIndex: Int = 0
    var youTubePlayer: XCDYouTubeVideoPlayerViewController?
    var initialTouchPoint: CGPoint = .zero
    
    // MARK: - View Model -
    
    var viewModel: StoriesViewModel?

    // MARK: - Life cycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppearance()
        imageViewHeader.sd_setImage(with: viewModel?.mainUrlImage(at: pageIndex), placeholderImage: #imageLiteral(resourceName: "default-image"))
        labelTitle.text = viewModel?.title(at: pageIndex)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideoOrLoadImage(index: pageIndex)
    }
    
    // MARK: - Appearance -
    
    private func setupAppearance() {
        imageViewHeader.layer.cornerRadius = imageViewHeader.frame.width / 2
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        buttonNetflix.isHidden = true
    }
    
    // MARK: - Actions -
    
    @IBAction func buttonOpenNetflixAction(_ sender: UIButton) {
        SocialMedia.open(mediaType: .netflix, id: viewModel?.netflixId(at: pageIndex))
    }
    
    @IBAction func buttonCloseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Play or show image -
    
    private func playVideoOrLoadImage(index: Int?) {
        guard let index = index, let array = viewModel?.currentStoryItems(at: index), let item = array.first else {
            return
        }
        
        imageView.isHidden = item.content != .image
        videoView.isHidden = item.content != .video
        
        switch item.content {
        case .image:
            imageView.image = item.data as? UIImage
        case .video:
            viewModel?.loadVideo(at: index) { [weak self] (data) in
                guard let path = data as? String, let videoView = self?.videoView else {
                    return
                }
                
                self?.activityIndicator.isHidden = true
                self?.buttonNetflix.isHidden = false
                
                self?.youTubePlayer = XCDYouTubeVideoPlayerViewController(videoIdentifier: path)

                self?.youTubePlayer?.present(in: videoView)
                self?.youTubePlayer?.moviePlayer.play()
            }
        }
    }
    
    //MARK: - Transition -
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        imageViewHeader.isHidden = UIDevice.current.orientation != .portrait
        labelTitle.isHidden = imageViewHeader.isHidden
        buttonClose.isHidden = imageViewHeader.isHidden
        buttonNetflix.isHidden = imageViewHeader.isHidden
    }
    
    //MARK: - Status bar -
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
