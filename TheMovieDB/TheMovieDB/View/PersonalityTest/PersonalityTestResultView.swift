//
//  PersonalityTestResultView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/8/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import ProcessLoadingView
import GhostTypewriter

private let totalItems = 5
private let mainFontSize: CGFloat = 20
private let subFontSize: CGFloat = 22

class PersonalityTestResultView: UIViewController {
    // MARK: - Outlets -
    
    @IBOutlet weak var processLoadingView: ProcessLoadingView!
    @IBOutlet weak var labelResult: TypewriterLabel!
    @IBOutlet weak var buttonSeeMovies: UIButton!
    @IBOutlet weak var buttonDoTestAgain: UIButton!
    
    // MARK: - View Model -
    
    var viewModel: PersonalityTestViewModel?
    
    // MARK: - Properties -
    
    private var arrayImages: [(UIImage, UIColor?)] {
        var images = [(UIImage, UIColor?)]()
        
        for _ in 0..<totalItems {
            images.append((#imageLiteral(resourceName: "checkMark"), HexColor.secondary.color))
        }
        
        return images
    }
    
    private var processLoadingOptions: ProcessOptions {
        let options = ProcessOptions()
        
        options.inSpeed = 0.7
        options.setNumberOfItems(number: totalItems)
        options.ItemSize = 30
        if let text = labelResult.text {
            let minimalRadius: CGFloat = 90
            let radius = text.height * 0.35
            options.radius = radius < minimalRadius ? minimalRadius : radius
        }
        options.images = arrayImages
        options.stepComplete = totalItems
        options.bgColor = HexColor.primary.color
        options.mainTextColor = HexColor.text.color
        options.subTextColor = HexColor.secondary.color
        options.mainTextfont = UIFont.boldSystemFont(ofSize: mainFontSize)
        options.subTextfont = UIFont.boldSystemFont(ofSize: subFontSize)
        options.mainText = Titles.youGot.localized
        options.subText = viewModel?.userPersonalityTitle ?? ""
        
        return options
    }
    
    // MARK: - Life cycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.shared.lockOrientation()
        setupBindings()
        setupAppearance()
        labelResult.typingTimeInterval = Constants.typingTimeInterval
        labelResult.startTypewritingAnimation(completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        processLoadingView.start(completed: nil)
    }
    
    // MARK: - Appearance -
    
    func setupAppearance() {
        title = Titles.result.localized
        
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        
        buttonSeeMovies.backgroundColor = HexColor.secondary.color
        buttonDoTestAgain.backgroundColor = HexColor.secondary.color
        
        processLoadingView.options = processLoadingOptions
    }
    
    // MARK: - Bindings -
    
    func setupBindings() {
        viewModel?.resultText.bind(to: labelResult.reactive.text)
    }
    
    // MARK: - Actions -
    
    @IBAction func buttonShareAction(_ sender: UIBarButtonItem) {
        presentShareActivityController(image: takeScreenshot(shouldSave: false))
    }
    
    @IBAction func buttonDoTestAgainAction(_ sender: UIButton) {
        viewModel?.doTestAgain()
        navigationController?.popViewController(animated: true)
    }
}
