//
//  PersonalityTestResultView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/8/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import ProcessLoadingView

private let total = 5
private let mainFontSize: CGFloat = 22
private let subFontSize: CGFloat = 26

class PersonalityTestResultView: UIViewController {
    @IBOutlet weak var processLoadingView: ProcessLoadingView!
    @IBOutlet weak var textViewResult: UITextView!
    @IBOutlet weak var buttonSeeMovies: UIButton!
    
    var viewModel: PersonalityTestViewModel?
    
    var arrayImages: [(UIImage, UIColor?)] {
        var images = [(UIImage, UIColor?)]()
        
        for _ in 0..<total {
            images.append((#imageLiteral(resourceName: "checkMark"), HexColor.secondary.color))
        }
        
        return images
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBindings()
        setupAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        processLoadingView.start(completed: nil)
    }
    
    func setupAppearance() {
        navigationItem.titleView = nil
        title = Titles.result.rawValue
        
        buttonSeeMovies.backgroundColor = HexColor.secondary.color
        
        let options = ProcessOptions()
        options.setNumberOfItems(number: total)
        options.ItemSize = 30
        options.images = arrayImages
        options.stepComplete = total
        options.bgColor = HexColor.primary.color
        options.mainTextColor = HexColor.text.color
        options.subTextColor = HexColor.secondary.color
        options.mainTextfont = UIFont.boldSystemFont(ofSize: mainFontSize)
        options.subTextfont = UIFont.boldSystemFont(ofSize: subFontSize)
        options.mainText = Titles.youGot.rawValue
        options.subText = viewModel?.userPersonalityTitle ?? ""
        
        processLoadingView.options = options
    }
    
    func setupBindings() {
        viewModel?.resultText.bind(to: textViewResult.reactive.text)
    }
}
