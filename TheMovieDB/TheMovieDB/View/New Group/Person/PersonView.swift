//
//  PersonView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

class PersonView: UITableViewController {
    @IBOutlet weak var textViewBiography: UITextView!
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    @IBOutlet weak var labelBiographyFixed: UILabel!
    @IBOutlet weak var labelBirthday: UILabel!
    @IBOutlet weak var labelPlaceOfBirth: UILabel!
    @IBOutlet weak var labelAlsoKnownAs: UILabel!
    
    @IBOutlet weak var carouselMovies: iCarousel!

    @IBOutlet weak var buttonTwitterValue: UIButton!
    @IBOutlet weak var buttonInstagramValue: UIButton!
    @IBOutlet weak var buttonFacebookValue: UIButton!
    
    var viewModel: PersonViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppearance()
        setupBindings()
        viewModel?.delegate = self
        viewModel?.loadData()
    }
    
    func setupAppearance() {
        navigationItem.titleView = nil
        carouselMovies.type = .coverFlow2
        tableView.tableFooterView = UIView()
    }
    
    func setupBindings() {
        viewModel?.biography.bind(to: textViewBiography.reactive.text)
        viewModel?.birthday.bind(to: labelBirthday.reactive.text)
        viewModel?.placeOfBirth.bind(to: labelPlaceOfBirth.reactive.text)
        viewModel?.alsoKnownAs.bind(to: labelAlsoKnownAs.reactive.text)
        viewModel?.photo.bind(to: imageViewPhoto.reactive.image)
        viewModel?.isFacebookEnabled.bind(to: buttonFacebookValue.reactive.isEnabled)
        viewModel?.facebookTintColor.bind(to: buttonFacebookValue.reactive.tintColor)
        viewModel?.isInstagramEnabled.bind(to: buttonInstagramValue.reactive.isEnabled)
        viewModel?.instagramTintColor.bind(to: buttonInstagramValue.reactive.tintColor)
        viewModel?.isTwitterEnabled.bind(to: buttonTwitterValue.reactive.isEnabled)
        viewModel?.twitterTintColor.bind(to: buttonTwitterValue.reactive.tintColor)
    }
    
    @IBAction func buttonFacebookAction(_ sender: UIButton) {
        viewModel?.open(socialMediaType: .facebook)
    }
    
    @IBAction func buttonInstagramAction(_ sender: UIButton) {
        viewModel?.open(socialMediaType: .instagram)
    }
    
    @IBAction func buttonTwitterAction(_ sender: UIButton) {
        viewModel?.open(socialMediaType: .twitter)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            let spaceMargin: CGFloat = 8
            return labelBiographyFixed.frame.height + textViewBiography.contentSize.height + (spaceMargin * 2)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}

extension PersonView: iCarouselDelegate, iCarouselDataSource {
    
    // MARK: - iCarousel delegate and data source -
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if let viewModel = viewModel { return viewModel.numberOfCastMovies }
        return 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = XibView.instanceFromNib(MovieView.self)
        
        viewModel?.loadMovieImageData(at: index, handlerData: { (data) in
            if let data = data as? Data, let image = UIImage(data: data) {
                view.imageViewMovie.image = image
            }
        })
        
        return view
    }
}

extension PersonView: ViewModelDelegate {
    func reloadData() {
        title = viewModel?.personName
        
        tableView.reloadData()
        carouselMovies.reloadData()
    }
}