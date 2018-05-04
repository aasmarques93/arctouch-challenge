//
//  Appearance.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override func awakeFromNib() {
        navigationBar.barTintColor = HexColor.primary.color
        navigationBar.tintColor = HexColor.secondary.color
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : navigationBar.tintColor]
        navigationBar.isTranslucent = false
        navigationBar.isOpaque = true
        navigationBar.shadowImage = UIImage()
        
        currentNavigationController = self
    }
}

extension UIViewController {
    open override func awakeFromNib() {
        view.backgroundColor = HexColor.primary.color
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = #imageLiteral(resourceName: "logo-movie-db")
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
}

extension UITabBar {
    open override func awakeFromNib() {
        isTranslucent = false
        barTintColor = HexColor.primary.color
        tintColor = HexColor.secondary.color
    }
}

extension UIImage {
    func imageResize(sizeChange: CGSize) -> UIImage {
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}

extension CAGradientLayer {
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 1, y: 0)
    }
    
    func creatGradientImage() -> UIImage? {
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}

extension UITabBarController {
    open override func awakeFromNib() {
        tabBar.tintColor = HexColor.primary.color
    }
}

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    
    var startPoint : CGPoint {
        return points.startPoint
    }
    
    var endPoint : CGPoint {
        return points.endPoint
    }
    
    var points : GradientPoints {
        get {
            switch(self) {
            case .topRightBottomLeft:
                return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
            case .topLeftBottomRight:
                return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1,y: 1))
            case .horizontal:
                return (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5))
            case .vertical:
                return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
            }
        }
    }
}

extension UIView {
    fileprivate struct AssociatedKeys {
        static var colorStyle = ""
    }
    
    @IBInspectable var colorStyle: String? {
        get {
            guard let object = objc_getAssociatedObject(self, &AssociatedKeys.colorStyle) as? String else {
                return nil
            }
            return object
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.colorStyle, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if let label = self as? UILabel {
            label.textColor = HexColor.color(from: colorStyle) ?? HexColor.text.color
            return
        }
        if let textView = self as? UITextView {
            textView.textColor = HexColor.color(from: colorStyle) ?? HexColor.text.color
            return
        }
        if let segmentedControl = self as? UISegmentedControl {
            segmentedControl.tintColor = HexColor.color(from: colorStyle) ?? HexColor.secondary.color
            return
        }
        if let stepper = self as? UIStepper {
            stepper.tintColor = HexColor.color(from: colorStyle) ?? HexColor.secondary.color
            return
        }
        if let activityIndicator = self as? UIActivityIndicatorView {
            activityIndicator.color = HexColor.color(from: colorStyle) ?? HexColor.secondary.color
            return
        }
        
        if let _ = self as? UITextField { return }
        
        if let button = self as? UIButton {
            button.setTitleColor(HexColor.text.color, for: .normal)
            button.tintColor = HexColor.color(from: colorStyle) ?? HexColor.secondary.color
            return
        }
        
        self.backgroundColor = HexColor.color(from: colorStyle) ?? self.backgroundColor
    }
    
    func applyGradient(colors: [UIColor], orientation: GradientOrientation = .horizontal) -> Void {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        layer.insertSublayer(gradient, at: 0)
    }
    
    func removeGradient() {
        if let sublayers = layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
    }
}

class GradientView: UIView {
    @IBInspectable var startColor: UIColor = .black { didSet { updateColors() } }
    @IBInspectable var endColor: UIColor = .white { didSet { updateColors() } }
    @IBInspectable var startLocation: Double = 0.05 { didSet { updateLocations() } }
    @IBInspectable var endLocation: Double = 0.95 { didSet { updateLocations() } }
    @IBInspectable var horizontalMode: Bool = false { didSet { updatePoints() } }
    @IBInspectable var diagonalMode: Bool = false { didSet { updatePoints() } }
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}
