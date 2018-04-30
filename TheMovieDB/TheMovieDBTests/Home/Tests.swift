//
//  Tests.swift
//  TheMovieDBTests
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import XCTest

@testable import TheMovieDB

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        EnvironmentHost.shared.current = .mock
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
