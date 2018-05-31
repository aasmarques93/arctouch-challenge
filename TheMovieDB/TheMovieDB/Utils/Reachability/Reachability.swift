//
//  Reachability.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/31/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Alamofire

class Reachability {
    static let manager = NetworkReachabilityManager(host: "www.google.com")
    
    static var isReachable: Bool {
        guard let isReachable = manager?.isReachable else {
            return false
        }
        return isReachable
    }
    
    static func startListening(connection handler: @escaping Handler<Bool>) {        
        manager?.startListening()
        
        guard isReachable else {
            DispatchQueue.main.async { handler(false) }
            return
        }
        
        manager?.listener = { status in
            switch status {
                case .notReachable:
                    handler(false)
                    print("The network is not reachable")
                case .unknown :
                    handler(false)
                    print("It is unknown whether the network is reachable")
                case .reachable(.ethernetOrWiFi):
                    handler(true)
                    print("The network is reachable over the WiFi connection")
                case .reachable(.wwan):
                    handler(true)
                    print("The network is reachable over the WWAN connection")
            }
        }
        
    }
}
