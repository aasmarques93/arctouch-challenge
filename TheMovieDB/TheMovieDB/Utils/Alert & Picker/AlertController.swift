//
//  AlertController.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

typealias AlertHandler = () -> Swift.Void

extension UIViewController {
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else {
            return UIAlertController(style: .alert)
        }
        return alert
    }
}

extension UIAlertController {
    convenience init(style: UIAlertControllerStyle,
                     source: UIView? = nil,
                     title: String? = nil,
                     message: String? = nil,
                     tintColor: UIColor? = nil) {
        
        self.init(title: title, message: message, preferredStyle: style)
        
        let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
        let root = UIApplication.shared.keyWindow?.rootViewController?.view
        
        if let source = source {
            popoverPresentationController?.sourceView = source
            popoverPresentationController?.sourceRect = source.bounds
        } else if isPad, let source = root, style == .actionSheet {
            popoverPresentationController?.sourceView = source
            popoverPresentationController?.sourceRect = CGRect(x: source.bounds.midX, y: source.bounds.midY, width: 0, height: 0)
            popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
        }
        
        guard let color = tintColor else {
            return
        }
        
        view.tintColor = color
    }
    
    func show(title: String? = nil, message: String?, mainButton: String? = nil, mainAction: AlertHandler? = nil, secondaryButton: String? = nil, secondaryAction: AlertHandler? = nil) {
        
        let aTitle = title ?? ""
        let alert = UIAlertController(title: aTitle, message: message, preferredStyle: .alert)
        
        let mButton = UIAlertAction(title: mainButton ?? Titles.done.localized, style: .default, handler: { (_) in
            if let mainAction = mainAction { mainAction() }
        })
        alert.addAction(mButton)
        
        if let secondaryButton = secondaryButton {
            let sButton = UIAlertAction(title: secondaryButton, style: .default, handler: { (_) in
                if let secondaryAction = secondaryAction { secondaryAction() }
            })
            alert.addAction(sButton)
        }
        
        alert.presentAnywhere()
    }
    
    func showPickerView(title: String?,
                        message: String?,
                        actionTitle: String? = nil,
                        selectedRow: Int? = nil,
                        values: [[String]]?,
                        handler: @escaping (Int?) -> ()) {
        
        guard let values = values else {
            return
        }
        
        let alert = UIAlertController(style: .actionSheet, title: title, message: message)
        
        let pickerViewSelectedValue: PickerViewController.Index = (column: 0, row: selectedRow ?? 0)
        alert.addPickerView(values: values, initialSelection: pickerViewSelectedValue) { viewController, picker, index, values in
            handler(index.row)
        }
        
        alert.addAction(title: actionTitle ?? "Done", style: .cancel)
        alert.show()
    }
    
    func show(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(self, animated: animated, completion: completion)
        }
    }
    
    func addAction(image: UIImage? = nil, title: String, color: UIColor? = nil, style: UIAlertActionStyle = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) {
    
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled
        
        // button image
        if let image = image {
            action.setValue(image, forKey: "image")
        }
        
        // button title color
        if let color = color {
            action.setValue(color, forKey: "titleTextColor")
        }
        
        addAction(action)
    }
    
    func set(title: String?, font: UIFont, color: UIColor) {
        if title != nil {
            self.title = title
        }
        
        setTitle(font: font, color: color)
    }
    
    func setTitle(font: UIFont, color: UIColor) {
        guard let title = self.title else {
            return
        }
        
        let attributes: [NSAttributedStringKey: Any] = [.font: font, .foregroundColor: color]
        let attributedTitle = NSMutableAttributedString(string: title, attributes: attributes)
        setValue(attributedTitle, forKey: "attributedTitle")
    }
    
    func set(message: String?, font: UIFont, color: UIColor) {
        if message != nil {
            self.message = message
        }
        setMessage(font: font, color: color)
    }
    
    func setMessage(font: UIFont, color: UIColor) {
        guard let message = self.message else {
            return
        }
        
        let attributes: [NSAttributedStringKey: Any] = [.font: font, .foregroundColor: color]
        let attributedMessage = NSMutableAttributedString(string: message, attributes: attributes)
        setValue(attributedMessage, forKey: "attributedMessage")
    }
    
    func set(viewController: UIViewController?, height: CGFloat? = nil) {
        guard let viewController = viewController else {
            return
        }
        setValue(viewController, forKey: "contentViewController")
        guard let height = height else {
            return
        }
        viewController.preferredContentSize.height = height
        preferredContentSize.height = height
    }
}
