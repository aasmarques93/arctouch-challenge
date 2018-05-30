//
//  StoriesPageViewController.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class StoriesPageViewController: UIPageViewController {
    // MARK: - View Model -
    
    var viewModel: StoriesViewModel?
    
    // MARK: - Properties -
    
    private var pageAfter = 1
    private var pageBefore = 0
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        view.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        view.frame = view.bounds
        viewModel?.delegate = self
        viewModel?.loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    // MARK: - Page Controller -
    
    private func viewControllerAtIndex(index: Int?) -> StoriesView? {
        guard let isItemAvailable = viewModel?.isItemAvailable(at: index), isItemAvailable else {
            dismiss(animated: true, completion: nil)
            return nil
        }
        
        let storiesView = instantiate(viewController: StoriesView.self, from: .generic)
        storiesView.pageIndex = index ?? 0
        storiesView.viewModel = viewModel
        viewModel?.setCurrentIndex(index)
        
        return storiesView
    }
    
    private func goNextPage(fowardTo position: Int) {
        guard let storiesView = viewControllerAtIndex(index: position) else {
            return
        }
        
        let viewControllers = [storiesView]
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    
    // MARK: - Status Bar -
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension StoriesPageViewController: ViewModelDelegate {
    
    // MARK: - ViewModelDelegate -
    
    func reloadData() {
        guard let storiesView = viewControllerAtIndex(index: viewModel?.currentIndex) else {
            return
        }
        
        let viewControllers = [storiesView]
        setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
    }
}

extension StoriesPageViewController: UIPageViewControllerDataSource {
    
    // MARK: - UIPageViewControllerDataSource -
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewController = viewController as? StoriesView else {
            return nil
        }
        
        var index = viewController.pageIndex
        guard index != 0 && index != NSNotFound else {
            return nil
        }
        
        index -= 1
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? StoriesView else {
            return nil
        }
        
        var index = viewController.pageIndex
        guard index != NSNotFound else {
            return nil
        }
        
        index += 1
        guard let numberOfPages = viewModel?.numberOfPages, index < numberOfPages else {
            return nil
        }
        
        return viewControllerAtIndex(index: index)
    }
}
