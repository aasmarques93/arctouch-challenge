//
//  Alert.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

typealias AlertHandler = () -> Swift.Void

class AlertComponent {
    static func show(title: String? = nil, message: String?, mainButton : String? = nil, mainAction: AlertHandler? = nil, secondaryButton: String? = nil, secondaryAction: AlertHandler? = nil) {
        
        let aTitle = title ?? ""
        let alertController = UIAlertController(title: aTitle, message: message, preferredStyle: .alert)
        
        let mButton = UIAlertAction(title: mainButton ?? Titles.done.rawValue, style: .default, handler: { (_) in
            if let mainAction = mainAction { mainAction() }
        })
        alertController.addAction(mButton)
        
        if let secondaryButton = secondaryButton {
            let sButton = UIAlertAction(title: secondaryButton, style: .default, handler: { (_) in
                if let secondaryAction = secondaryAction { secondaryAction() }
            })
            alertController.addAction(sButton)
        }
        alertController.presentAnywhere()
    }
}
