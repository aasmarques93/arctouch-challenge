//
//  PersonView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

private let reuseIdentifier = "PersonCell"

class PersonView: UIViewController {
    @IBOutlet weak var textViewBiography: UITextView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var carouselMovies: iCarousel!

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
        viewModel?.photo.bind(to: imageViewPhoto.reactive.image)
    }
}

extension PersonView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.heightForPersonalInfo(at: indexPath) ?? 0
    }
}

extension PersonView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfPersonalInfo ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        cell.alternateBackground(at: indexPath, secondaryColor: HexColor.secondary.color.withAlphaComponent(0.1))
        
        cell.textLabel?.text = viewModel?.personalInfoTitle(at: indexPath)
        cell.detailTextLabel?.text = viewModel?.personalInfoDescription(at: indexPath)
        
        return cell
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
        view.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width * 0.6, height: view.frame.height * 0.6)
        
        viewModel?.loadMovieImageData(at: index, handlerData: { (data) in
            if let data = data as? Data, let image = UIImage(data: data) {
                view.imageViewMovie.image = image
            }
        })
        
        return view
    }
}

extension PersonView: PersonViewModelDelegate {
    func reloadData() {
        title = viewModel?.personName
        
        tableView.reloadData()
        carouselMovies.reloadData()
    }
}
