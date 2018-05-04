//
//  Session.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Foundation
import Alamofire

struct Session {
    // MARK: - Properties -
    static var shared = Session()
    
    var manager: SessionManager?
    
    init() {
        configureApiManager()
    }
    
    /// This method configure session manager of Alamofire
    private mutating func configureApiManager() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        
        let serverTrustPolicy : [String: ServerTrustPolicy] = [
            "\(EnvironmentHost.shared.host)" : .disableEvaluation
        ]
        
        self.manager = SessionManager(configuration: configuration,
                                      delegate: SessionDelegate(),
                                      serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicy))
    }
}

