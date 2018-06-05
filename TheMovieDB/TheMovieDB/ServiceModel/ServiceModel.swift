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
import Moya

typealias HandlerCallback = () -> Swift.Void
typealias HandlerObject = (Any?) -> Swift.Void
typealias Handler<Element> = (Element) -> Swift.Void

// MARK: - Service Model -

protocol ServiceModel {
}

extension ServiceModel {
    // MARK: - Service Delegate Methods -
    
    func request(method: Moya.Method = .get,
                 requestUrl: RequestUrl,
                 environmentBase: EnvironmentBase = .theMovieDB,
                 parameters: [String: Any]? = nil,
                 urlParameters: [String: Any]? = nil,
                 handlerObject: @escaping HandlerObject) {
        
        guard environmentBase != .mock else {
            JSONWrapper.json(from: requestUrl) { (json) in
                if let json = json { handlerObject(json) }
            }
            return
        }
        
        if !verifyConnection() {
            handlerObject(ReachabilityError.notConnected.rawValue)
            return
        }
        
        let requestBase = RequestBase(requestUrl: requestUrl,
                                      environmentBase: environmentBase,
                                      method: method,
                                      urlParameters: urlParameters,
                                      parameters: parameters)
        
//        plugins: [NetworkLoggerPlugin(verbose: true)]
        let provider = MoyaProvider<RequestBase>()
        provider.request(requestBase) { (result) in
            do {
                let response = try result.dematerialize()
                let json = try response.mapJSON()
                
                guard let array = json as? [Any] else {
                    handlerObject(JSON(json))
                    return
                }
                
                var arrayObject = [JSON]()
                array.forEach({ (object) in
                    arrayObject.append(JSON(object))
                })
                
                handlerObject(arrayObject)
            } catch {
                let printableError = error as CustomStringConvertible
                handlerObject(printableError.description)
            }
        }
    }
    
    func loadImage(path: String?, environmentBase: EnvironmentBase = .imagesTheMovieDB, handlerData: @escaping HandlerObject) {
        if !verifyConnection() {
            handlerData(ReachabilityError.notConnected.rawValue)
            return
        }
        
        let requestBase = RequestBase(environmentBase: environmentBase,
                                      customPath: path ?? "",
                                      method: .get)
        
        let provider = MoyaProvider<RequestBase>()
        provider.request(requestBase) { (result) in
            do {
                let response = try result.dematerialize()
                handlerData(response.data)
            } catch {
                let printableError = error as CustomStringConvertible
                handlerData(printableError.description)
            }
        }
    }
    
    func imageUrl(with path: String?, environmentBase: EnvironmentBase = .imagesTheMovieDB) -> String {
        var url = environmentBase.path
        if let path = path { url += path }
        return url
    }
    
    // MARK: - Verifications -
    
    func verifyConnection() -> Bool {
        guard let reachabilityNetwork = Alamofire.NetworkReachabilityManager(host: "www.google.com") else {
            return false
        }
        return reachabilityNetwork.isReachable
    }
}

// MARK: - Reachability Custom Error -

enum ReachabilityError: String {
    case notConnected = "CONNECTION_VERIFY"
    case requestTimeout = "REQUEST_TIMEOUT"
}

struct GenericServiceModel: ServiceModel {
    
}
