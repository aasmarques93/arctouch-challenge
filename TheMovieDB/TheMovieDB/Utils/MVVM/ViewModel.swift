//
//  ViewModel.swift
//  Water
//
//  Created by Arthur Augusto Sousa Marques on 27/01/17.
//  Copyright © 2017 Arthur Augusto Sousa Marques. All rights reserved.
//

import UIKit

class ViewModel : NSObject {
    // MARK: - Constructors -
    
    override init() {
        
    }
    
    init(object : Any) {
        
    }
    
    //Create an unwrapped string from any object
    func valueDescription(_ object : Any?) -> String {
        if let object = object {
            return "\(object)"
        }
        return ""
    }
}
