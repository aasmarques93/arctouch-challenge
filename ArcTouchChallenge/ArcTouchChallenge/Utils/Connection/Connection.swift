//
//  Connection.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias handlerResponseJSON = (Alamofire.DataResponse<Any>) -> Swift.Void
typealias handlerResponseObject = (Any) -> Swift.Void
typealias handlerDownloadResponseData = (Alamofire.DownloadResponse<Data>) -> Swift.Void

class Connection {
    
    // MARK: - Properties -
    
    static let shared = Connection()
    
    var headers : HTTPHeaders?
    var cookies = [HTTPCookie]()
    var stringCookies = ""
    
    // MARK: - Request Methods -
    
    /// Request Method
    ///
    /// - Parameters:
    ///   - url: Request link
    ///   - responseJSON: Handler to completion
    static func request(_ url : String, responseJSON: @escaping handlerResponseJSON) {
        
        let manager = Session.shared.apiManager()
        
        manager.request(url).responseJSON { (response) in
            print("URL: \(url)\nJSON Response: \(response)")
            
            responseJSON(response)
        }
        
    }
    
    /// Request Method
    ///
    /// - Parameters:
    ///   - url: request link
    ///   - method: HTTP Method
    ///   - parameters: Dictionary representation
    ///   - dataResponseJSON: Handler to completion
    static func request(_ url : String, method : HTTPMethod, parameters : [String : Any]?, dataResponseJSON: @escaping handlerResponseJSON) {
        
        let manager = Session.shared.apiManager()
        manager.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: Connection.shared.headers).responseJSON { (response) in
            
            print("URL: \(url)\nJSON Response: \(response)\n")
            
            if response.response?.statusCode == 403 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "expiredSessionObserver"), object: nil)
            }
            
            dataResponseJSON(response)
        }
        
    }
    
    
    /// Request Data Method
    ///
    /// - Parameters:
    ///   - url: Request link
    ///   - method: HTTP Method
    ///   - parameters: Dictionary representation
    ///   - dataResponse: Handler to completion
    static func requestData(_ url : String, method : HTTPMethod, parameters : [String : Any]?, dataResponse: @escaping (Data?) -> ()) {
        let manager = Session.shared.apiManager()
        manager.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: Connection.shared.headers).responseJSON { (response) in
            //print("URL: \(url)")
            
            dataResponse(response.data)
        }
        
    }
}
