//
//  Connection.swift
//  Water
//
//  Created by Arthur Augusto Sousa Marques on 30/01/17.
//  Copyright © 2017 Arthur Augusto Sousa Marques. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias HandlerObject = (Any?) -> Swift.Void

// MARK: - Service Model -

struct ServiceModel {
    // MARK: - Properties -
    var url : String?
    var parameters : [String:Any]?
    
    // MARK: - Constructors -
    init() { }
    
    init(url : String?) {
        self.url = url
    }
    
    init(url : String?, parameters : [String:Any]?) {
        self.url = url
        self.parameters = parameters
    }
    
    // MARK: - Service Delegate Methods -
    
    func request(method: HTTPMethod = .get,
                 requestUrl: RequestUrl,
                 stringUrl: String? = nil,
                 parameters: [String:Any]? = nil,
                 urlParameters: [String:Any]? = nil,
                 handlerObject: @escaping HandlerObject,
                 handlerJson: HandlerObject? = nil) {
        
        if EnvironmentHost.shared.current == .mock {
            JSONWrapper.json(from: requestUrl) { (json) in
                if let json = json { handlerObject(json) }
            }
            return
        }
        
        var url = ""
        
        if let stringUrl = stringUrl {
            url = stringUrl
        } else {
            url = self.requestUrl(type: requestUrl, parameters: urlParameters)
        }
        
        if !verifyConnection() {
            let error = ReachabilityError.notConnected.rawValue
            handlerObject(error)
            return
        }
        
        Connection.shared.request(url: url, method: method, parameters: parameters) { (dataResponse) in
            if let value = dataResponse.result.value {
                handlerJson?(value)
                
                if let array = value as? [Any] {
                    var arrayObject = [JSON]()
                    
                    for object in array {
                        arrayObject.append(JSON(object))
                    }
                    
                    handlerObject(arrayObject)
                    
                    return
                }
                
                handlerObject(JSON(value))
                return
            }
            
            handlerObject(ReachabilityError.requestTimeout.rawValue)
            handlerJson?(nil)
        }
    }
    
    func loadImage(path: String?, handlerData: @escaping HandlerObject) {
        var url = keyManagerFile(key: EnvironmentBase.images)
        if let path = path { url += path }
        
        if !verifyConnection() {
            let error = ReachabilityError.notConnected.rawValue
            handlerData(error)
            return
        }
        
        Connection.shared.requestData(url: url, method: .get, parameters: nil) { (data) in
            if let data = data {
                handlerData(data)
            } else {
                handlerData(ReachabilityError.requestTimeout.rawValue)
            }
        }
    }
    
    func imageUrl(with path: String?) -> String {
        var url = keyManagerFile(key: EnvironmentBase.images)
        if let path = path { url += path }
        return url
    }
    
    // MARK: - Verifications -
    
    static func verifyResult(_ object : Any?) -> String? {
        if let error = object as? ReachabilityError {
            return error.rawValue
        }
        if let error = object as? Error {
            return error.localizedDescription
        }
        return nil
    }
    
    func verifyConnection() -> Bool {
        if let reachabilityNetwork = Alamofire.NetworkReachabilityManager(host: "www.google.com") {
            
            if reachabilityNetwork.isReachable {
                return true
            }
        }
        return false
    }
    
    // MARK: - File manager - Link requests -
    
    private func requestUrl(type: RequestUrl, parameters: [String:Any]? = nil) -> String {
        if type.rawValue.contains("http") {
            return type.rawValue
        }
        
        var link = ""
        
        link += keyManagerFile(key: EnvironmentHost.shared.current)
        
        guard let parameters = parameters else {
            link += keyManagerFile(key: type)
            link += appendApiKey(to: link)
            return link
        }
        
        link += createUrl(from: keyManagerFile(key: type), parameters: parameters)
        
        return link
    }
    
    func keyManagerFile(key:Any) -> String{
        if let key = key as? EnvironmentBase {
            let file = FileManager.load(name: FileName.environmentLink)
            if let host = file?.object(forKey: key.rawValue) as? String {
                return host
            }
        }
        
        if let key = key as? RequestUrl {
            let file = FileManager.load(name: FileName.requestUrl)
            if let link = file?.object(forKey: key.rawValue) as? String {
                return link
            }
        }
        
        return ""
    }
    
    func createUrl(from string: String, parameters: [String:Any]) -> String {
        var url = string
        
        for parameter in parameters {
            if url.contains("{\(parameter.key)}") {
                let array = url.components(separatedBy: "{\(parameter.key)}")
                if array.count == 2 { url = "\(array[0])\(parameter.value)\(array[1])" }
            }
        }
        
        url += appendApiKey(to: url)
        
        return url
    }
    
    func appendApiKey(to url: String) -> String {
        return "api_key=\(keyManagerFile(key: RequestUrl.apiKey))"
    }
}

// MARK: - Reachability Custom Error -

enum ReachabilityError: String {
    case notConnected = "CONNECTION_VERIFY"
    case requestTimeout = "REQUEST_TIMEOUT"
}
