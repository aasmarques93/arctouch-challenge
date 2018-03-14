//
//  Alert.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

typealias AlertHandler = () -> Swift.Void

class AlertView {
    enum AlertType {
        case error
        case success
    }
    
    static var shared = AlertView()
    
    var title : String?
    var message : String?
    var image : UIImage?
    
    var type: AlertType? {
        didSet {
            if type == .success {
                title = "Sucesso"
                colorPrimary = HexColor.secondary.color
            } else {
                title = "Erro"
                colorPrimary = HexColor.accent.color
            }
            
            self.image = UIImage(named: "")
        }
    }
    
    var colorPrimary = HexColor.accent.color
    
    func show(title: String? = nil, message: String?, type: AlertType? = nil, mainButton : String? = nil, mainAction: AlertHandler? = nil, secondaryButton: String? = nil, secondaryAction: AlertHandler? = nil) {
        
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
