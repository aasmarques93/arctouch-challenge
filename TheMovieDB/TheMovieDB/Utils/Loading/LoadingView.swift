//
//  LoadingView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    var loadingTag = 900
    
    var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
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
        
        if !containsBackgroundColor { self.backgroundColor = UIColor.clear }
        
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
        if let window = AppDelegate.shared.window {
            start(in: window, text: text)
        }
    }
    
    func start(in view: UIView, text: String? = nil) {
        self.text = text
        view.addSubview(self)
    }
    
    func start(with frame: CGRect, text: String? = nil) {
        self.text = text
        if let window = AppDelegate.shared.window { window.addSubview(self) }
    }
}

struct Loading {
    static var shared = Loading()
    
    var loadingView: LoadingView?
    
    mutating func start() {
        var frame: CGRect = .zero
        if let window = AppDelegate.shared.window { frame = window.frame }
        loadingView = LoadingView(frame: frame)
        loadingView?.startInWindow()
    }
    
    func stop() {
        loadingView?.stop()
    }
}
