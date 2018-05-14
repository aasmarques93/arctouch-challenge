//
//  StoriesView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
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
    @IBOutlet weak var imageViewHeader: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonClose: UIButton!
    
    var viewModel: StoriesViewModel?
    
    var storiesPageViewController: StoriesPageViewController?
    var youTubePlayer: XCDYouTubeVideoPlayerViewController?
    
    var pageIndex: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupAppearance()
        
        imageViewHeader.sd_setImage(with: viewModel?.mainUrlImage(at: pageIndex), placeholderImage: #imageLiteral(resourceName: "logo-movie-db"), options: [], completed: nil)
        labelTitle.text = viewModel?.title(at: pageIndex)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideoOrLoadImage(index: 0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)        
        UIApplication.shared.isStatusBarHidden = false
    }
    
    func setupAppearance() {
        UIApplication.shared.isStatusBarHidden = true
        imageViewHeader.layer.cornerRadius = imageViewHeader.frame.width / 2
    }
    
    @IBAction func buttonCloseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Play or show image
    func playVideoOrLoadImage(index: NSInteger) {
        guard let isStoryItemAvailable = viewModel?.isStoryItemAvailable(at: index), isStoryItemAvailable else {
            return
        }
        
        guard let array = viewModel?.currentStoryItems(at: index) else {
            return
        }
        
        let item = array[index]
        imageView.isHidden = item.content != .image
        videoView.isHidden = item.content != .video
        
        switch item.content {
        case .image:
            imageView.image = item.data as? UIImage
        case .video:
            guard let path = item.data as? String else {
                return
            }
            
            youTubePlayer = XCDYouTubeVideoPlayerViewController(videoIdentifier: path)

            youTubePlayer?.present(in: videoView)
            youTubePlayer?.moviePlayer.play()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        imageViewHeader.isHidden = UIDevice.current.orientation != .portrait
        labelTitle.isHidden = imageViewHeader.isHidden
        buttonClose.isHidden = imageViewHeader.isHidden
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
