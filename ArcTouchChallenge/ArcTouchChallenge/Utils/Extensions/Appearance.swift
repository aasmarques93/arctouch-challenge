//
//  Appearance.swift
//  ArcTouchChallenge
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
    func applyGradient(colors: [UIColor], orientation: GradientOrientation = .horizontal) -> Void {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.bounds.height)
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
}

class Button: UIButton {
    @IBInspectable var isPrimary: Bool = true
    @IBInspectable var isSecondary: Bool = false
    @IBInspectable var isLink: Bool = false
    
    override func awakeFromNib() {
        layer.masksToBounds = true
        layer.cornerRadius = bounds.height / 2
        
        setTitleColor(HexColor.text.color, for: .normal)
        
        if isPrimary {
            titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
            applyGradient(colors: [HexColor.secondary.color, HexColor.darkSecondary.color])
        } else if isSecondary {
            titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
            backgroundColor = HexColor.secondary.color
        } else if isLink {
            titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
            titleLabel?.textColor = HexColor.secondary.color
            backgroundColor = UIColor.clear
            
            if let text = titleLabel?.text {
                let titleString = NSMutableAttributedString(string: text)
                titleString.addAttribute(NSAttributedStringKey.underlineStyle,
                                         value: NSUnderlineStyle.styleSingle.rawValue,
                                         range: NSMakeRange(0, text.count))
                self.setAttributedTitle(titleString, for: .normal)
            }
        } else {
            titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
            backgroundColor = HexColor.secondary.color
        }
    }
}

class Label: UILabel {
    @IBInspectable var isTitle: Bool = false
    @IBInspectable var isNumber: Bool = false
    @IBInspectable var fontSize: CGFloat = 17
    @IBInspectable var fontWeight: String = "Light"
    
    override func awakeFromNib() {
        if isTitle {
            textColor = HexColor.text.color
            return
        }
        
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.1
    }
}

class TextField: UITextField, UITextFieldDelegate {
    @IBInspectable var title: String?
    @IBInspectable var titleColor: UIColor? = HexColor.text.color
    @IBInspectable var customTextColor: UIColor?
    @IBInspectable var separatorColor: UIColor?
    @IBInspectable var isNumberText: Bool = false
    
    var textFieldMaskDelegate : TextFieldMaskDelegate?
    var titleLabel = UILabel()
    var separator = UIView()
    
    var messageError = "" {
        didSet {
            isInvalidField = messageError != ""
        }
    }
    
    var isInvalidField: Bool = true {
        didSet {
            titleLabel.text = messageError != "" ? messageError : title
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.textColor = isInvalidField ? HexColor.secondary.color : titleColor ?? HexColor.text.color
            separator.backgroundColor = isInvalidField ? HexColor.secondary.color : titleColor ?? HexColor.text.color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        
        if let titleLabel = createTitleLabel() {
            addSubview(titleLabel)
        }
        
        contentVerticalAlignment = isVerticallyCentered ? .center : .bottom
        textColor = customTextColor ?? HexColor.text.color
        borderStyle = .none
        
        if isNumberText { font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.semibold) }
        
        separator = UIView(frame: CGRect(x: 0, y: bounds.maxY, width: bounds.width, height: 0.5))
        
        if Device.iPhone5 {
            separator.frame = CGRect(x: 0, y: bounds.maxY, width: bounds.width - 44, height: 0.5)
        }
        
        separator.backgroundColor = textColor
        if let separatorColor = separatorColor { separator.backgroundColor = separatorColor }
    }
    
    func clearError() {
        messageError = ""
    }
    
    func createTitleLabel() -> UILabel? {
        if let title = title {
            let font = UIFont.systemFont(ofSize: 12)
            
            let stringTextAsNSString = title as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,
                                                                                 height: CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSAttributedStringKey.font: font],
                                                                    context: nil).size
            
            titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: labelStringSize.height))
            titleLabel.isUserInteractionEnabled = false
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.text = title
            titleLabel.textColor = titleColor ?? HexColor.text.color
            titleLabel.font = font
            titleLabel.backgroundColor = UIColor.clear
            return titleLabel
        }
        
        return nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let textFieldMaskDelegate = textFieldMaskDelegate {
            if let method = textFieldMaskDelegate.didBeginEditing { method(textField) }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textFieldMaskDelegate = textFieldMaskDelegate {
            if let method = textFieldMaskDelegate.didEndEditing { method(textField) }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textFieldMaskDelegate = textFieldMaskDelegate {
            if let method = textFieldMaskDelegate.shouldReturn { return method(textField) }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textFieldMaskDelegate = textFieldMaskDelegate {
            if let method = textFieldMaskDelegate.shouldChange { return method(textField, range, string) }
        }
        return true
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
