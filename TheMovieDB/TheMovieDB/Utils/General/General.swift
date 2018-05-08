//
//  General.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

typealias HandlerGeneric = (_ object: Any?) -> Swift.Void

enum Storyboard: String {
    case personalityTest = "PersonalityTest"
    case main = "Main"
    case movie = "Movie"
    case tvShow = "TVShow"
    case popularPeople = "PopularPeople"
    case search = "Search"
    case generic = "Generic"
}

var currentNavigationController: UINavigationController?

func instantiate<T:UIViewController>(viewController: T.Type, from storyboard: Storyboard = .main) -> T {
    return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: viewController.identifier) as! T
}
