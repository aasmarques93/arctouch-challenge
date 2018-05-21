//
//  ViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 27/01/17.
//  Copyright © 2017 Arthur Augusto Sousa Marques. All rights reserved.
//

import UIKit

@objc protocol ViewModelDelegate: class {
    @objc optional func reloadData()
    @objc optional func showAlert(message: String?)
}

protocol ViewModel {
    func loadData()
}

extension ViewModel {
    // Create an unwrapped string from any object
    func valueDescription(_ object: Any?) -> String {
        if let object = object { return "\(object)" }
        return ""
    }
    
    // Show error if object has returno status message
    func showError(with object: Model) throws {
        if let statusMessage = object.statusMessage, statusMessage != "" {
            throw Error(message: statusMessage)
        }
    }
    
    // Load image data at path
    func loadImageData(at path: String?, handlerData: @escaping HandlerObject) {
        Singleton.shared.serviceModel.loadImage(path: path, handlerData: { (data) in
            handlerData(data)
        })
    }
}

struct Error: Swift.Error {
    let file: StaticString
    let function: StaticString
    let line: UInt
    let message: String

    init(message: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        self.file = file
        self.function = function
        self.line = line
        self.message = message
    }
}
