//
//  LoadingView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

private let margin: CGFloat = 16
private let activityHeight: CGFloat = 40
private let alphaBackground: CGFloat = 0.7
private let fontSize: CGFloat = 14

class LoadingView: UIView {
    private var activityIndicator: NVActivityIndicatorView {
        let type = NVActivityIndicatorType(rawValue: Int.random(lower: 0, upper: 32))
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: margin, width: activityHeight, height: activityHeight),
                                                        type: type)
        
        activityIndicator.center = CGPoint(x: self.center.x, y: self.center.y)
        activityIndicator.color = HexColor.secondary.color
        activityIndicator.startAnimating()
        
        return activityIndicator
    }
    
    private var text: String? {
        didSet {
            if let text = text {
                let labelText = UILabel(frame: CGRect(x: 0,
                                                      y: activityIndicator.frame.maxY + margin,
                                                      width: frame.width,
                                                      height: activityHeight))
                labelText.text = text
                labelText.numberOfLines = 3
                labelText.textAlignment = .center
                labelText.textColor = activityIndicator.color
                
                if #available(iOS 8.2, *) {
                    labelText.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.light)
                }
                
                labelText.removeFromSuperview()
                self.addSubview(labelText)
            }
        }
    }
    
    init(frame: CGRect = .zero, text: String? = nil, backgroundColor: UIColor? = nil) {
        super.init(frame: frame)
        self.backgroundColor = backgroundColor ?? HexColor.primary.color.withAlphaComponent(alphaBackground)
        self.addSubview(activityIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startInWindow(text: String? = nil) {
        guard let window = AppDelegate.shared.window else {
            return
        }
        self.text = text
        window.addSubview(self)
    }
    
    func stop() {
        removeFromSuperview()
    }
}

struct Loading {
    static var shared = Loading()
    var loadingView: LoadingView?
    
    mutating func start(text: String?, backgroundColor: UIColor? = nil) {
        loadingView = LoadingView(frame: AppDelegate.shared.window?.frame ?? .zero,
                                  text: text,
                                  backgroundColor: backgroundColor)
        loadingView?.startInWindow()
    }
    
    func stop() {
        loadingView?.stop()
    }
}
