//
//  ViewModel.swift
//  Water
//
//  Created by Arthur Augusto Sousa Marques on 27/01/17.
//  Copyright © 2017 Arthur Augusto Sousa Marques. All rights reserved.
//

import UIKit

@objc protocol ViewModelDelegate: class {
    @objc optional func reloadData()
    @objc optional func showError(message: String?)
}

protocol ViewModel {
    func loadData()
}

extension ViewModel {
    // Create an unwrapped string from any object
    func valueDescription(_ object : Any?) -> String {
        if let object = object { return "\(object)" }
        return ""
    }
    
    // Show error if object has returno status message
    func showError(with object: Model) -> Bool {
        if let statusMessage = object.statusMessage, statusMessage != "" { return true }
        return false
    }
    
    // Load image data at path
    func loadImageData(at path: String?, handlerData: @escaping HandlerObject) {
        ServiceModel().loadImage(path: path, handlerData: { (data) in
            handlerData(data)
        })
    }
}
