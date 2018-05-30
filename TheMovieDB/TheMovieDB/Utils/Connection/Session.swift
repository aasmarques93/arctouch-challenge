//
//  Session.swift
//  TheMovieDB
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
    var host: String {
        let file = FileManager.load(name: FileName.environmentLink)
        if let host = file?.object(forKey: EnvironmentBase.theMovieDB.rawValue) as? String {
            return host
        }
        return ""
    }
    
    init() {
        configureApiManager()
    }
    
    private mutating func configureApiManager() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        
        let serverTrustPolicy: [String: ServerTrustPolicy] = [
            "\(host)": .disableEvaluation
        ]
        
        self.manager = SessionManager(configuration: configuration,
                                      delegate: SessionDelegate(),
                                      serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicy))
    }
}

