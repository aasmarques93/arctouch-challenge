//
//  RouletteView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/15/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond
import GhostTypewriter
import XCDYouTubeKit

class RouletteView: UIViewController {
    @IBOutlet weak var labelMessage: TypewriterLabel!
    @IBOutlet weak var buttonSpin: UIButton!
    
    @IBOutlet weak var viewResult: UIView!
    
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var imageViewResult: UIImageView!
    @IBOutlet weak var labelTitleResult: UILabel!
    @IBOutlet weak var labelIMDBResult: UILabel!
    @IBOutlet weak var labelRottenTomatoesResult: UILabel!
    @IBOutlet weak var labelDateResult: UILabel!
    @IBOutlet weak var labelTypeResult: UILabel!
    @IBOutlet weak var textViewOverviewResult: UITextView!
    
    let viewModel = RouletteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.roulette.localized
        setupAppearance()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.delegate = self
        viewModel.loadData()
        labelMessage.startTypewritingAnimation(completion: nil)
    }
    
    func setupAppearance() {
        labelMessage.typingTimeInterval = 0.03
        buttonSpin.backgroundColor = HexColor.secondary.color
    }
    
    func setupBindings() {
        viewModel.isLabelMessageHidden.bind(to: labelMessage.reactive.isHidden)
        viewModel.isViewResultHidden.bind(to: viewResult.reactive.isHidden)
        viewModel.titleResult.bind(to: labelTitleResult.reactive.text)
        viewModel.dateResult.bind(to: labelDateResult.reactive.text)
        viewModel.movieShowType.bind(to: labelTypeResult.reactive.text)
        viewModel.imdbResult.bind(to: labelIMDBResult.reactive.text)
        viewModel.rottenTomatoesResult.bind(to: labelRottenTomatoesResult.reactive.text)
        viewModel.overviewResult.bind(to: textViewOverviewResult.reactive.text)
    }
    
    @IBAction func buttonOpenVideoAction(_ sender: UIButton) {
        guard let path = viewModel.videoKey else {
            return
        }
        
        let youTubePlayer = XCDYouTubeVideoPlayerViewController(videoIdentifier: path)
        youTubePlayer.moviePlayer.play()
        present(youTubePlayer, animated: true, completion: nil)
    }
    
    @IBAction func buttonSpinAction(_ sender: UIButton) {
        viewModel.doSpin()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? RouletteFilterView else {
            return
        }
        
        viewController.viewModel = viewModel
    }
}

extension RouletteView: ViewModelDelegate {
    func reloadData() {
        imageViewResult.sd_setImage(with: viewModel.imageResultUrl, placeholderImage: #imageLiteral(resourceName: "default-image"), options: [], completed: nil)
        imageViewBackground.sd_setImage(with: viewModel.imageResultUrl, placeholderImage: #imageLiteral(resourceName: "default-image"), options: [], completed: nil)
    }
    
    func showAlert(message: String?) {
        alertController?.show(message: message)
    }
}
