//
//  HomeTests.swift
//  TheMovieDBTests
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import XCTest

@testable import TheMovieDB

class HomeTests: Tests {
    
    // MARK: - Spy Delegate -
    
    class SpyHomeViewModelDelegate: HomeViewModelDelegate {
        
        // MARK: - Properties -
        
        var reloadDataExpectation: XCTestExpectation?
        var showErrorExpectation: XCTestExpectation?
        
        // MARK: - Home View Model Delegate -
        
        func reloadData(at index: Int) {
            if index == 0 { reloadDataExpectation?.fulfill() }
        }
        
        func showAlert(message: String?) {
            showErrorExpectation?.fulfill()
        }
    }
    
    // MARK: - Properties -
    
    var viewModel: MoviesViewModel?
    var section = Genre.nowPlaying.index
    
    override func setUp() {
        super.setUp()
        
        viewModel = MoviesViewModel()
        viewModel?.loadData()
    }
    
    override func tearDown() {
        super.tearDown()
        
        viewModel = nil
    }
    
    func getIndexPathRows() -> (last: Int, invalid: Int) {
        let numberOfItems = viewModel!.numberOfNowPlayingMovies
        return (last: numberOfItems - 1, invalid: numberOfItems + 1)
    }
    
    // MARK: - Movies Tests -
    
    func testLoadData() {
        let delegate = SpyHomeViewModelDelegate()
        viewModel?.delegate = delegate
        
        let expectationMethod = expectation(description: "Should perform reloadData()")
        delegate.reloadDataExpectation = expectationMethod
        
        viewModel?.loadData()
        
        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertFalse(self.viewModel?.numberOfNowPlayingMovies == 0)
        }
    }
    
    func testMovieAtIndexPath() {
        let rows = getIndexPathRows()
        
        XCTAssertNotNil(viewModel?.movie(at: section, row: rows.last))
        XCTAssertNil(viewModel?.movie(at: section, row: rows.invalid))
    }
}
