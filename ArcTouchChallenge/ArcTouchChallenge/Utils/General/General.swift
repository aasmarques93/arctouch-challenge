//
//  General.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

typealias HandlerGeneric = (_ object: Any?) -> Swift.Void

enum Storyboard: String {
    case main = "Main"
}

var currentNavigationController: UINavigationController?

//MARK: Instantiate View Controller from a Storyboard
func instantiateFrom(storyboard: Storyboard, identifier: String) -> UIViewController {
    return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: identifier)
}

func instantiateInitialViewController(storyboard: Storyboard) -> UIViewController? {
    return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateInitialViewController()
}

func showFadeView(storyboard: Storyboard, identifier: String, from viewController: UIViewController) {
    let view = instantiateFrom(storyboard: storyboard, identifier: identifier)
    view.modalPresentationStyle = .custom
    view.modalTransitionStyle = .crossDissolve
    viewController.present(view, animated: true, completion: nil)
}

func performView(identifier: String, storyboard: Storyboard, navigationController: UINavigationController?) {
    if let navigationController = navigationController {
        let viewController = instantiateFrom(storyboard: storyboard, identifier: identifier)
        navigationController.pushViewController(viewController, animated: true)
    }
}

func presentView(identifier: String, storyboard: Storyboard, from viewController: UIViewController?) {
    if let viewController = viewController {
        let view = instantiateFrom(storyboard: storyboard, identifier: identifier)
        view.present(viewController, animated: true, completion: nil)
    }
}

enum TabBarItem: Int {
    case home = 0
    case profile = 1
}

func setTabBarSelectedIndex(at tabBarController: UITabBarController?, from: TabBarItem, to: TabBarItem) {
    if let tabBarController = tabBarController {
        if let viewControllers = tabBarController.viewControllers {
            let viewController = viewControllers[to.rawValue]
            tabBarController.selectedViewController = viewController
        }
    }
}
