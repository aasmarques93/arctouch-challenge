//
//  LoadingView.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension ViewModel {
    fileprivate struct AssociatedKeys {
        static var loadingView: LoadingView?
    }
    
    var loadingView: LoadingView {
        get {
            if let result = objc_getAssociatedObject(self, &AssociatedKeys.loadingView) as? LoadingView {
                return result
            }
            
            var frame: CGRect = .zero
            
            if let window = sharedAppDelegate.window {
                frame = window.frame
            }
            
            self.loadingView = LoadingView(frame: frame)
            
            return self.loadingView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadingView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

class LoadingView : UIView {
    var loadingTag = 900
    
    var activityIndicator: NVActivityIndicatorView {
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 16, width: 40, height: 40), type: .ballClipRotate)
        
        activityIndicator.center = CGPoint(x: self.center.x, y: self.center.y)
        activityIndicator.color = HexColor.secondary.color
        activityIndicator.startAnimating()
        
        return activityIndicator
    }
    
    var labelText = UILabel()
    
    var text: String? {
        didSet {
            if let text = text {
                labelText = UILabel(frame: CGRect(x: 0, y: activityIndicator.frame.maxY+16, width: frame.width, height: 40))
                labelText.text = text
                labelText.numberOfLines = 3
                labelText.textAlignment = .center
                labelText.textColor = activityIndicator.color
                
                if #available(iOS 8.2, *) {
                    labelText.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
                }
                
                labelText.removeFromSuperview()
                self.addSubview(labelText)
            }
        }
    }
    
    init(frame: CGRect = .zero, text: String? = nil, containsBackgroundColor: Bool = true) {
        super.init(frame: frame)
        
        self.tag = loadingTag
        self.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
        if !containsBackgroundColor {
            self.backgroundColor = UIColor.clear
        }
        
        self.addSubview(activityIndicator)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.stop))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func stop() {
        self.removeFromSuperview()
    }
    
    func startInWindow(text: String? = nil) {
        if let window = sharedAppDelegate.window {
            start(in: window, text: text)
        }
    }
    
    func start(in view : UIView, text: String? = nil) {
        self.text = text
        
        view.addSubview(self)
    }
    
    func start(with frame : CGRect, text: String? = nil) {
        self.text = text
        
        if let window = sharedAppDelegate.window {
            window.addSubview(self)
        }
    }
}
