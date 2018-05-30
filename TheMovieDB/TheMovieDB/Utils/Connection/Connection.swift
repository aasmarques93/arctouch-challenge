//
//  Connection.swift
//  TheMovieDB
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

struct Connection {
    // MARK: - Properties -
    
    static let shared = Connection()
    
    private var headers: HTTPHeaders?
    private var cookies = [HTTPCookie]()
    private var stringCookies = ""
    
    // MARK: - Request Methods -
    
    func request(url: String,
                 method: HTTPMethod = .get,
                 parameters: [String: Any]? = nil,
                 dataResponseJSON: @escaping handlerResponseJSON) {
        
        Session.shared.manager?.request(url,
                                        method: method,
                                        parameters: parameters,
                                        encoding: JSONEncoding.default,
                                        headers: Connection.shared.headers).responseJSON { (response) in
            
                                            print("URL: \(url)\nJSON Response: \(response)\n")
                                            dataResponseJSON(response)
        }
        
    }
    
    func requestData(url: String,
                     method: HTTPMethod,
                     parameters: [String: Any]?,
                     dataResponse: @escaping (Data?) -> ()) {
        
        Session.shared.manager?.request(url,
                                        method: method,
                                        parameters: parameters,
                                        encoding: JSONEncoding.default,
                                        headers: Connection.shared.headers).responseJSON { (response) in

                                            dataResponse(response.data)
        }
    }
}
