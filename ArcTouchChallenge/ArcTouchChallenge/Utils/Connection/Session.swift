//
//  Session.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Foundation
import Alamofire

class Session {
    
    // MARK: - Properties -
    
    static let shared = Session()
    
    private var manager : SessionManager?
    
    // MARK: - Management -
    
    /// This method configure session manager of Alamofire,
    /// timeout request, and server trust policy.
    ///
    /// - Returns: Session Manager configured
    func apiManager() -> SessionManager {
        if let manager = manager { return manager }
        
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
        return self.manager!
    }
    
    
}

