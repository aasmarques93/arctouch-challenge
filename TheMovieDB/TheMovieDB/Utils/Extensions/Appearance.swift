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
        
        if self is UITextField { return }
        
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

extension UILabel {
    var stringHeight : CGFloat {
        get {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 44))
            
            label.numberOfLines = 100
            label.font = self.font
            label.text = self.text
            label.sizeToFit()
            
            return label.frame.height
        }
        set {
            
        }
    }
    func addShadow(with offset : CGSize, opacity : Float, radius : CGFloat) {
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}

extension UISearchBar {
    @IBInspectable var textColor: UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as? UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }
        
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as? UITextField  {
                textField.textColor = newValue
            }
        }
    }
}

extension UITextView {
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        scrollRangeToVisible(NSMakeRange(0, 0))
    }
}

extension UIView {
    /* The color of the shadow. Defaults to opaque black. Colors created
     * from patterns are currently NOT supported. Animatable. */
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    /* The shadow offset. Defaults to (0, -3). Animatable. */
    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }
    
    /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return self.borderColor
        }
        set {
            layer.masksToBounds = true
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.borderWidth
        }
        set {
            layer.masksToBounds = true
            layer.borderWidth = newValue
        }
    }
    
    func addAllSidesConstraints(_ parent: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1.0, constant: 0))
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1.0, constant: 0))
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1.0, constant: 0))
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1.0, constant: 0))
    }
    
    func getSubviewsMaxHeight() -> CGFloat {
        var max:CGFloat = 0
        
        for subview in self.subviews {
            if subview.bounds.size.height > max {
                max = subview.bounds.size.height
            }
        }
        if max == 0 { max = self.bounds.size.height }
        return max
    }
    
    func contentHeight() -> CGFloat {
        var r = CGRect.zero
        for subview in self.subviews {
            r = r.union(subview.frame)
        }
        return r.height
    }
    
    func findCollectionView() -> UICollectionView? {
        for subview in self.subviews {
            if subview is UICollectionView {
                return (subview as! UICollectionView)
            }
        }
        return nil
    }
    
    func setFrameHeight(_ height: CGFloat) {
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: height)
    }
    
    func setFrameWidth(_ width: CGFloat) {
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: frame.height)
    }
    
    func embed(_ parentViewController: UIViewController, child: UIViewController) {
        parentViewController.addChildViewController(child)
        child.view.frame = self.bounds
        self.addSubview(child.view)
        child.didMove(toParentViewController: parentViewController)
    }
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func rounded(_ radius: CGFloat) {
        layer.shadowOffset = CGSize(width: shadowOffset.x, height: shadowOffset.y)
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.cornerRadius = radius
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: shadowRadius).cgPath
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.shadowColor = shadowColor?.cgColor
        mask.shadowOpacity = shadowOpacity
        mask.shadowOffset = CGSize(width: shadowOffset.x, height: shadowOffset.y)
        mask.shadowRadius = radius
        self.layer.mask = mask
    }
    
    static func findTableViewInSubviews(view: UIView) -> UITableView? {
        for subview in view.subviews {
            if subview is UITableView {
                return subview as? UITableView
                
            } else {
                for subsubview in subview.subviews {
                    if subsubview is UITableView {
                        return subsubview as? UITableView
                    }
                }
            }
        }
        return nil
    }
    
    static func findScrollViewInSubViews(view: UIView) -> UIScrollView? {
        for subview in view.subviews {
            if subview is UIScrollView {
                return subview as? UIScrollView
            }
        }
        return nil
    }
    
    func changeSelfContainerHeightConstraint(_ newConstant: CGFloat, animated: Bool = false) {
        //Find height constraint
        guard let container = superview else {
            return
        }
        
        var heightConstraint: NSLayoutConstraint?
        
        for constraint in container.constraints {
            if constraint.firstAttribute == .height {
                heightConstraint = constraint
                continue
            }
        }
        
        //Change value animated
        if heightConstraint != nil {
            if animated {
                UIView.animate(withDuration: 0.3, animations: {
                    heightConstraint?.constant = newConstant
                    container.layoutIfNeeded()
                    self.layoutIfNeeded()
                })
            } else {
                heightConstraint?.constant = newConstant
            }
        }
    }
    
    func addCorner(radius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func addBorder(color: UIColor = .black, width: CGFloat = 1) {
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func addShadow(color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 2, size: CGSize = CGSize(width: -1, height: 1), rect: CGRect? = nil) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = size
        self.layer.shadowRadius = radius
    }
}
