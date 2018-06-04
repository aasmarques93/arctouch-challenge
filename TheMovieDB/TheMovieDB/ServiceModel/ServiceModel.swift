//
//  Connection.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 30/01/17.
//  Copyright © 2017 Arthur Augusto Sousa Marques. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias HandlerCallback = () -> Swift.Void
typealias HandlerObject = (Any?) -> Swift.Void
typealias Handler<Element> = (Element) -> Swift.Void

// MARK: - Service Model -

protocol ServiceModel {
}

extension ServiceModel {
    // MARK: - Service Delegate Methods -
    
    func request(method: HTTPMethod = .get,
                 requestUrl: RequestUrl,
                 environmentBase: EnvironmentBase = .theMovieDB,
                 stringUrl: String? = nil,
                 parameters: [String: Any]? = nil,
                 urlParameters: [String: Any]? = nil,
                 handlerObject: @escaping HandlerObject) {
        
        guard environmentBase != .mock else {
            JSONWrapper.json(from: requestUrl) { (json) in
                if let json = json { handlerObject(json) }
            }
            return
        }
        
        var url = ""
        
        if let stringUrl = stringUrl {
            url = stringUrl
        } else {
            url = self.requestUrl(type: requestUrl, environmentBase: environmentBase, parameters: urlParameters)
        }
        
        if !verifyConnection() {
            let error = ReachabilityError.notConnected.rawValue
            handlerObject(error)
            return
        }
        
        Connection.request(url: url, method: method, parameters: parameters) { (dataResponse) in
            if let value = dataResponse.result.value {
                if let array = value as? [Any] {
                    var arrayObject = [JSON]()
                    
                    array.forEach({ (object) in
                        arrayObject.append(JSON(object))
                    })
                    
                    handlerObject(arrayObject)
                    
                    return
                }
                
                handlerObject(JSON(value))
                return
            }
            
            handlerObject(ReachabilityError.requestTimeout.rawValue)
        }
    }
    
    func loadImage(path: String?, environmentBase: EnvironmentBase = .imagesTheMovieDB, handlerData: @escaping HandlerObject) {
        var url = keyManagerFile(key: environmentBase)
        if let path = path { url += path }
        
        if !verifyConnection() {
            let error = ReachabilityError.notConnected.rawValue
            handlerData(error)
            return
        }
        
        Connection.requestData(url: url, method: .get, parameters: nil) { (data) in
            if let data = data {
                handlerData(data)
            } else {
                handlerData(ReachabilityError.requestTimeout.rawValue)
            }
        }
    }
    
    func imageUrl(with path: String?, environmentBase: EnvironmentBase = .imagesTheMovieDB) -> String {
        var url = keyManagerFile(key: environmentBase)
        if let path = path { url += path }
        return url
    }
    
    // MARK: - Verifications -
    
    func verifyConnection() -> Bool {
        if let reachabilityNetwork = Alamofire.NetworkReachabilityManager(host: "www.google.com") {
            if reachabilityNetwork.isReachable {
                return true
            }
        }
        return false
    }
    
    // MARK: - File manager - Link requests -
    
    func requestUrl(type: RequestUrl, environmentBase: EnvironmentBase, parameters: [String: Any]? = nil) -> String {
        if type.rawValue.contains("http") {
            return type.rawValue
        }
        
        var link = ""
        
        link += keyManagerFile(key: environmentBase)
        
        guard let parameters = parameters else {
            link += keyManagerFile(key: type)
            guard environmentBase == .theMovieDB else {
                return link
            }
            return link + appendApiKey(to: link)
        }
        
        link += createUrl(from: keyManagerFile(key: type), environmentBase: environmentBase, parameters: parameters)
        
        return link
    }
    
    func keyManagerFile(key: Any) -> String{
        if let key = key as? EnvironmentBase {
            let file = FileManager.load(name: FileName.environmentLink)
            if let host = file?.object(forKey: key.rawValue) as? String {
                return host
            }
        }
        
        if let key = key as? RequestUrl {
            let file = FileManager.load(name: FileName.requestLinks)
            if let link = file?.object(forKey: key.rawValue) as? String {
                return link
            }
        }
        
        return ""
    }
    
    func createUrl(from string: String, environmentBase: EnvironmentBase, parameters: [String: Any]) -> String {
        var url = string
        
        parameters.forEach { (parameter) in
            if url.contains("{\(parameter.key)}") {
                let array = url.components(separatedBy: "{\(parameter.key)}")
                if array.count == 2 { url = "\(array[0])\(parameter.value)\(array[1])" }
            }
        }
        
        guard environmentBase == .theMovieDB else {
            return url
        }
        
        return url + appendApiKey(to: url)
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

struct GenericServiceModel: ServiceModel {
    
}
