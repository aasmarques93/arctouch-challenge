//
//  RouletteView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/15/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class RouletteView: UITableViewController {
    @IBOutlet var viewFooter: UIView!
    
    @IBOutlet weak var textFieldGenres: UITextField!
    @IBOutlet weak var textFieldIMDB: UITextField!
    @IBOutlet weak var textFieldRottenTomatoes: UITextField!
    
    @IBOutlet weak var switchMovies: UISwitch!
    @IBOutlet weak var switchTVShows: UISwitch!
    
    @IBOutlet weak var buttonSpin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
    }
    
    func setupAppearance() {
        buttonSpin.backgroundColor = HexColor.secondary.color
    }
    
    @IBAction func buttonSpinAction(_ sender: UIButton) {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewFooter.frame.height
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewFooter
    }
}
