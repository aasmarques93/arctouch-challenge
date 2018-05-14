//
//  SearchHeaderView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

@objc protocol SearchHeaderViewDelegate: class {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    @objc optional func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    @objc optional func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
}

class SearchHeaderView: XibView {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var labelTitle: UILabel!
    
    weak var delegate: SearchHeaderViewDelegate?
    
    var title: String?
    var placeholder: String?
    
    class func instantateFromNib(title: String?, placeholder: String?, textAlignment: NSTextAlignment = .center) -> SearchHeaderView {
        let view = XibView.instanceFromNib(SearchHeaderView.self)
        
        view.searchBar.delegate = view
        view.labelTitle.text = title
        view.labelTitle.textAlignment = textAlignment
        view.searchBar.placeholder = placeholder
        
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = HexColor.primary.color
    }
}

extension SearchHeaderView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        delegate?.searchBarSearchButtonClicked(searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let method = delegate?.searchBarCancelButtonClicked { method(searchBar) }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let method = delegate?.searchBar { return method(searchBar, range, text) }
        return true
    }
}
