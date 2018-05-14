//
//  StoriesPageViewController.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class StoriesPageViewController: UIPageViewController {
    var viewModel: StoriesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.frame = view.bounds
        viewModel?.delegate = self
        viewModel?.loadData()
    }
    
    func viewControllerAtIndex(index: Int?) -> StoriesView? {
        guard let isItemAvailable = viewModel?.isItemAvailable(at: index), isItemAvailable else {
            dismiss(animated: true, completion: nil)
            return nil
        }
        
        let storiesView = instantiate(viewController: StoriesView.self, from: .generic)
        storiesView.viewModel = viewModel
        storiesView.pageIndex = index
        storiesView.storiesPageViewController = self
        
        viewModel?.setCurrentIndex(index)
        
        return storiesView
    }
    
    func goNextPage(fowardTo position: Int) {
        guard let storiesView = viewControllerAtIndex(index: position) else {
            return
        }
        
        let viewControllers = [storiesView]
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension StoriesPageViewController: ViewModelDelegate {
    func reloadData() {
        guard let storiesView = viewControllerAtIndex(index: viewModel?.currentIndex) else {
            return
        }
        
        let viewControllers = [storiesView]
        setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
    }
}

extension StoriesPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewController = viewController as? StoriesView else {
            return nil
        }
        
        guard let index = viewController.pageIndex, index != 0 && index != NSNotFound else {
            return nil
        }
        
        return viewControllerAtIndex(index: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? StoriesView else {
            return nil
        }
        
        guard let index = viewController.pageIndex, index != NSNotFound else {
            return nil
        }
        
        guard let isItemAvailable = viewModel?.isItemAvailable(at: index + 1), isItemAvailable else {
            return nil
        }
        
        return viewControllerAtIndex(index: index + 1)
    }
}
