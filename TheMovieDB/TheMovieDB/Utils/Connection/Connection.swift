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
    
    private static var headers: HTTPHeaders?
    
    // MARK: - Request Methods -
    
    static func request(url: String,
                 method: HTTPMethod = .get,
                 parameters: [String: Any]? = nil,
                 dataResponseJSON: @escaping handlerResponseJSON) {
        
        Session.shared.manager?.request(url,
                                        method: method,
                                        parameters: parameters,
                                        encoding: JSONEncoding.default,
                                        headers: headers).responseJSON { (response) in
            
//                                            print("URL: \(url)\nJSON Response: \(response)\n")
                                            dataResponseJSON(response)
        }
        
    }
    
    static func requestData(url: String,
                     method: HTTPMethod,
                     parameters: [String: Any]?,
                     dataResponse: @escaping (Data?) -> ()) {
        
        Session.shared.manager?.request(url,
                                        method: method,
                                        parameters: parameters,
                                        encoding: JSONEncoding.default,
                                        headers: headers).responseJSON { (response) in

                                            dataResponse(response.data)
        }
    }
}
