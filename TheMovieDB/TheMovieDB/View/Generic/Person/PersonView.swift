//
//  PersonView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond
import AXPhotoViewer

class PersonView: UITableViewController {
    // MARK: - Outlets -
    
    @IBOutlet weak var textViewBiography: UITextView!
    
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    @IBOutlet weak var labelBiographyFixed: UILabel!
    @IBOutlet weak var labelBirthday: UILabel!
    @IBOutlet weak var labelPlaceOfBirth: UILabel!
    @IBOutlet weak var labelAlsoKnownAs: UILabel!
    
    @IBOutlet weak var carouselMovies: iCarousel!

    @IBOutlet weak var buttonTwitterValue: UIButton!
    @IBOutlet weak var buttonInstagramValue: UIButton!
    @IBOutlet weak var buttonFacebookValue: UIButton!
    
    // MARK: - View Model -
    
    var viewModel: PersonViewModel?
    
    // MARK: - Life cycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppearance()
        setupBindings()
        viewModel?.delegate = self
        viewModel?.loadData()
    }
    
    // MARK: - Appearance -
    
    private func setupAppearance() {
        carouselMovies.type = .coverFlow2
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Bindings -
    
    private func setupBindings() {
        viewModel?.biography.bind(to: textViewBiography.reactive.text)
        viewModel?.birthday.bind(to: labelBirthday.reactive.text)
        viewModel?.placeOfBirth.bind(to: labelPlaceOfBirth.reactive.text)
        viewModel?.alsoKnownAs.bind(to: labelAlsoKnownAs.reactive.text)
        viewModel?.isFacebookEnabled.bind(to: buttonFacebookValue.reactive.isEnabled)
        viewModel?.facebookTintColor.bind(to: buttonFacebookValue.reactive.tintColor)
        viewModel?.isInstagramEnabled.bind(to: buttonInstagramValue.reactive.isEnabled)
        viewModel?.instagramTintColor.bind(to: buttonInstagramValue.reactive.tintColor)
        viewModel?.isTwitterEnabled.bind(to: buttonTwitterValue.reactive.isEnabled)
        viewModel?.twitterTintColor.bind(to: buttonTwitterValue.reactive.tintColor)
    }
    
    // MARK: - Actions -
    
    @IBAction func buttonPhotoAction(_ sender: UIButton) {
        viewModel?.presentPhotos()
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

    // MARK: - Table view data source -
    
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
        view.imageViewMovie.sd_setImage(with: viewModel?.movieImageUrl(at: index), placeholderImage: #imageLiteral(resourceName: "default-image"))
        return view
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let viewController = instantiate(viewController: MovieDetailView.self, from: .movie)
        viewController.viewModel = viewModel?.movieDetailViewModel(at: index)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PersonView: ViewModelDelegate {
    
    // MARK: - ViewModelDelegate -
    
    func reloadData() {
        title = viewModel?.personName
        
        if let value = viewModel?.personName {
            FabricUtils.logEvent(message: "\(Messages.didSelect.localized) \(value)")
        }
        
        imageViewPhoto.sd_setImage(with: viewModel?.imageUrl)
        imageViewBackground.sd_setImage(with: viewModel?.imageUrl)
        
        tableView.reloadData()
        carouselMovies.reloadData()
    }
}
