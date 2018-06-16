//
//  FabricUtils.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/7/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Foundation
import Crashlytics

class FabricUtils {
    static func forceCrash() {
        Crashlytics.sharedInstance().crash()
    }
    
    static func logEvent(name: Titles = .click, message: String, attributesTitle: Titles = .event) {
        var attribute = ""
        if let viewController = UIApplication.topViewController() {
            attribute += "\(viewController.reusableIdentifier): "
        }
        attribute += message

        Answers.logCustomEvent(withName: name.rawValue, customAttributes: [attributesTitle.rawValue: attribute])
    }
    
    static func recordNonFatalError(message: String, file: StaticString = #file) {
        let output: String
        
        if let filename = URL(string: String(describing: file))?.lastPathComponent.components(separatedBy: ".").first {
            output = "\(filename)"
        } else {
            output = "\(file)"
        }
        
        var userInfo = [String: Any]()
        userInfo["message"] = message
        let error = NSError(domain: output, code: -1001, userInfo: userInfo)
        
        Crashlytics.sharedInstance().recordError(error)
        CrashLog(message)
    }
}

func CrashLog(_ message: String, file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
    let output: String
    
    if let filename = URL(string: String(describing: file))?.lastPathComponent.components(separatedBy: ".").first {
        output = "\(filename).\(function) line \(line) $ \(message)"
    } else {
        output = "\(file).\(function) line \(line) $ \(message)"
    }
    
    #if DEBUG
    CLSNSLogv("%@", getVaList([output]))
    #else
    CLSLogv("%@", getVaList([output]))
    #endif
}
