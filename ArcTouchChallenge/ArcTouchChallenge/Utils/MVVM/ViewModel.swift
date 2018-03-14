//
//  ViewModel.swift
//  Water
//
//  Created by Arthur Augusto Sousa Marques on 27/01/17.
//  Copyright © 2017 Arthur Augusto Sousa Marques. All rights reserved.
//

import UIKit

class ViewModel : NSObject {
    override init() {
        
    }
    
    init(object : Any) {
        
    }
    
    func valueDescription(_ object : Any?) -> String {
        if let object = object {
            return "\(object)"
        }
        return ""
    }
    
    func add(action : Selector, view : UIView) {
        if let button = view as? UIButton {
            button.addTarget(self, action: action, for: .touchUpInside)
        } else if let textField = view as? UITextField {
            textField.addTarget(self, action: action, for: .valueChanged)
        } else if let refreshControl = view as? UIRefreshControl {
            refreshControl.addTarget(self, action: action, for: .valueChanged)
        }
    }
}
