//
//  RouletteFilterView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/16/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

class RouletteFilterView: UITableViewController {
    var viewModel: RouletteViewModel?
    
    @IBOutlet weak var labelGenres: UILabel!
    @IBOutlet weak var labelIMDB: UILabel!
    @IBOutlet weak var labelRottenTomatoes: UILabel!
    
    @IBOutlet weak var switchMovies: UISwitch!
    @IBOutlet weak var switchTVShows: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = Titles.filter.localized
        setupBindings()
    }
    
    func setupBindings() {
        viewModel?.genres.bind(to: labelGenres.reactive.text)
        viewModel?.imdb.bind(to: labelIMDB.reactive.text)
        viewModel?.rottenTomatoes.bind(to: labelRottenTomatoes.reactive.text)
        viewModel?.isMoviesOn.bidirectionalBind(to: switchMovies.reactive.isOn)
        viewModel?.isTVShowsOn.bidirectionalBind(to: switchTVShows.reactive.isOn)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row < 3 else {
            return
        }
        
        alertController?.showPickerView(title: viewModel?.pickerTitle(at: indexPath.row),
                                        message: viewModel?.pickerMessage(at: indexPath.row),
                                        values: viewModel?.pickerValues(at: indexPath.row),
                                        handler: { [weak self] (index) in
                                            
                                            self?.viewModel?.didSelectPickerItem(at: indexPath.row, selectedIndex: index)
        })
    }
}
