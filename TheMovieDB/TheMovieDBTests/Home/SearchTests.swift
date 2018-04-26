//
//  SearchTests.swift
//  TheMovieDBTests
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import XCTest

@testable import TheMovieDB

class SearchTests: Tests {
    
    // MARK: - Spy Delegate -
    
    class SpySearchViewModelDelegate: SearchViewModelDelegate {
        
        // MARK: - Properties -
        
        var reloadDataExpectation: XCTestExpectation?
        var reloadMoviesListExpectation: XCTestExpectation?
        var showErrorExpectation: XCTestExpectation?
        
        // MARK: - Home View Model Delegate -
        
        func reloadData() {
            reloadDataExpectation?.fulfill()
        }
        
        func reloadMoviesList() {
            reloadMoviesListExpectation?.fulfill()
        }
        
        func showError(message: String?) {
            showErrorExpectation?.fulfill()
        }
    }
    
    // MARK: - Properties -
    
    var viewModel: SearchViewModel?
    
    override func setUp() {
        super.setUp()
        
        viewModel = SearchViewModel.shared
        viewModel?.loadData()
    }
    
    override func tearDown() {
        super.tearDown()
        
        viewModel = nil
    }
    
    func testLoadData() {
        let delegate = SpySearchViewModelDelegate()
        viewModel?.delegate = delegate
        
        let expectationMethod = expectation(description: "Should perform reloadData()")
        delegate.reloadDataExpectation = expectationMethod
        
        viewModel?.loadData()
        
        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertFalse(self.viewModel?.numberOfGenres == 0)
        }
    }
    
    func testLoadMoviesForSelectedGenre() {
        let delegate = SpySearchViewModelDelegate()
        viewModel?.delegate = delegate
        
        let expectationMethod = expectation(description: "Should perform reloadMoviesList()")
        delegate.reloadMoviesListExpectation = expectationMethod
        
        viewModel?.selectGenre(at: IndexPath(row: 0, section: 0))
        viewModel?.loadMoviesForSelectedGenre()
        
        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertFalse(self.viewModel?.numberOfMovies == 0)
        }
    }
}
