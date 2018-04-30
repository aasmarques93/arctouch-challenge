//
//  MovieDetailTests.swift
//  TheMovieDBTests
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import XCTest

@testable import TheMovieDB

class MovieDetailTests: Tests {
    
    // MARK: - Spy Delegate -
    
    class SpyMovieDetailViewModelDelegate: MovieDetailViewModelDelegate {
        
        // MARK: - Properties -
        
        var reloadDataExpectation: XCTestExpectation?
        var reloadVideosExpectation: XCTestExpectation?
        var reloadRecommendedMoviesExpectation: XCTestExpectation?
        var reloadSimilarMoviesExpectation: XCTestExpectation?
        
        // MARK: - Home View Model Delegate -
        
        func reloadData() {
            reloadDataExpectation?.fulfill()
        }
        
        func reloadVideos() {
            reloadVideosExpectation?.fulfill()
        }
        
        func reloadRecommendedMovies() {
            reloadRecommendedMoviesExpectation?.fulfill()
        }
        
        func reloadSimilarMovies() {
            reloadSimilarMoviesExpectation?.fulfill()
        }
    }
    
    // MARK: - Properties -
    
    var viewModel: MovieDetailViewModel?
    var moviesList = [Movie]()
    
    var movie: Movie? {
        didSet {
            if let object = movie {
                viewModel = MovieDetailViewModel(object)
                viewModel?.loadData()
            }
        }
    }
    
    override func setUp() {
        super.setUp()
        
        getMovies()
    }
    
    override func tearDown() {
        super.tearDown()
        
        viewModel = nil
    }
    
    func getMovies() {
        HomeServiceModel().getMovies(requestUrl: .nowPlaying) { (object) in
            if let object = object as? MoviesList, let results = object.results {
                self.movie = results.first
            }
        }
    }
    
    // MARK: - Movie Detail Tests -
    
    func testLoadData() {
        let delegate = SpyMovieDetailViewModelDelegate()
        viewModel?.delegate = delegate
        
        viewModel?.loadData()
        
        let reloadDataExpectation = expectation(description: "Should perform reloadData()")
        delegate.reloadDataExpectation = reloadDataExpectation
        delegate.reloadDataExpectation?.fulfill()
        
        let reloadVideosExpectation = expectation(description: "Should perform reloadVideosExpectation()")
        delegate.reloadVideosExpectation = reloadVideosExpectation
        delegate.reloadVideosExpectation?.fulfill()
        
        let reloadRecommendedMoviesExpectation = expectation(description: "Should perform reloadRecommendedMoviesExpectation()")
        delegate.reloadRecommendedMoviesExpectation = reloadRecommendedMoviesExpectation
        delegate.reloadRecommendedMoviesExpectation?.fulfill()

        let reloadSimilarMoviesExpectation = expectation(description: "Should perform reloadSimilarMoviesExpectation()")
        delegate.reloadSimilarMoviesExpectation = reloadSimilarMoviesExpectation
        delegate.reloadSimilarMoviesExpectation?.fulfill()
        
        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertFalse(self.viewModel?.movieDetail == nil)
            XCTAssertFalse(self.viewModel?.numberOfVideos == 0)
            XCTAssertFalse(self.viewModel?.numberOfMoviesRecommendations == 0)
            XCTAssertFalse(self.viewModel?.numberOfSimilarMovies == 0)
        }
    }
    
    func testMovieName() {
        XCTAssertFalse((viewModel?.movieName ?? "").isEmpty)
    }
}
