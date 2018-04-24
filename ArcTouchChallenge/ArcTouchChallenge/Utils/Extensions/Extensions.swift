//
//  Extensions.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

//Screen Related Values
var SCREEN_WIDTH: CGFloat {
    if let window = AppDelegate.shared.window { return window.frame.width }
    return 375
        
}
var SCREEN_HEIGHT: CGFloat {
    return AppDelegate.shared.window!.frame.height
}

extension UIViewController {
    fileprivate struct AssociatedKeys {
        static var pageIndex = 0
    }
    
    var pageIndex: Int? {
        get {
            guard let object = objc_getAssociatedObject(self, &AssociatedKeys.pageIndex) as? Int else {
                return nil
            }
            return object
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.pageIndex, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UITextField {
    fileprivate struct AssociatedKeys {
        static var rightInputAccessoryText = "OK"
        static var leftInputAccessoryText = ""
        static var selectedRow = 0
        static var isVerticallyCentered = false
    }

    func prepareDateField() {
        leftView = UIImageView(image: #imageLiteral(resourceName: "calendar_range"))
        leftViewMode = .always
        isVerticallyCentered = true
        awakeFromNib()
    }
    
    @IBInspectable var rightInputAccessoryText: String {
        get {
            guard let object = objc_getAssociatedObject(self, &AssociatedKeys.rightInputAccessoryText) as? String else {
                return "OK"
            }
            return object
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.rightInputAccessoryText, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBInspectable var leftInputAccessoryText: String {
        get {
            guard let object = objc_getAssociatedObject(self, &AssociatedKeys.leftInputAccessoryText) as? String else {
                return ""
            }
            return object
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.leftInputAccessoryText, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var selectedRow: Int? {
        get {
            guard let object = objc_getAssociatedObject(self, &AssociatedKeys.selectedRow) as? Int else {
                return nil
            }
            return object
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.selectedRow, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
    
    @IBInspectable var sidePadding: CGFloat {
        get {
            return self.sidePadding
        }
        set {
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: newValue))
            
            leftViewMode = UITextFieldViewMode.always
            leftView = padding
            
            rightViewMode = UITextFieldViewMode.always
            rightView = padding
        }
    }
    
    @IBInspectable var leftPadding: CGFloat {
        get {
            return self.leftPadding
        }
        set {
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 0))
            
            leftViewMode = UITextFieldViewMode.always
            leftView = padding
        }
    }
    
    @IBInspectable var rightPadding: CGFloat {
        get {
            return self.rightPadding
        }
        set {
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 0))
            
            rightViewMode = UITextFieldViewMode.always
            rightView = padding
        }
    }
    
    @IBInspectable var isVerticallyCentered: Bool {
        get {
            guard let object = objc_getAssociatedObject(self, &AssociatedKeys.isVerticallyCentered) as? Bool else {
                return false
            }
            return object
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.isVerticallyCentered, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override open func awakeFromNib() {
        if isVerticallyCentered {
            contentVerticalAlignment = .center
        }
        
        addInputAccessoryView()
    }
    
    func addInputAccessoryView() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black.withAlphaComponent(0.1)
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        var items = [UIBarButtonItem]()
        
        if leftInputAccessoryText != "" {
            let buttonLeft = UIBarButtonItem(title: leftInputAccessoryText,
                                             style: .done,
                                             target: self,
                                             action: #selector(inputAccessoryViewAction(_:)))
            buttonLeft.tag = 0
            buttonLeft.tintColor = HexColor.secondary.color
            
            items.append(buttonLeft)
        }
        
        items.append(spaceButton)
        
        if rightInputAccessoryText != "" {
            if rightInputAccessoryText == "OK" {
                let buttonRight = UIBarButtonItem(title: rightInputAccessoryText,
                                                  style: .done,
                                                  target: self,
                                                  action: #selector(resignFirstResponder))
                buttonRight.tag = 1
                buttonRight.tintColor = HexColor.secondary.color
                
                items.append(buttonRight)
            } else {
                let buttonRight = UIBarButtonItem(title: rightInputAccessoryText,
                                                  style: .done,
                                                  target: self,
                                                  action: #selector(inputAccessoryViewAction(_:)))
                buttonRight.tag = 1
                buttonRight.tintColor = HexColor.secondary.color
                
                items.append(buttonRight)
            }
        }
        
        toolBar.setItems(items, animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func inputAccessoryViewAction(_ sender: UIBarButtonItem) {
        var object = [String:Any]()
        
        object["selectedRow"] = selectedRow
        object["isRightButton"] = sender.tag == 1
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: inputAccessoryViewButtonSelectedObserver), object: object)
    }
}

var inputAccessoryViewButtonSelectedObserver = "inputAccessoryViewButtonSelectedObserver"

extension String {
    func formatCurrency(range : NSRange, string : String) -> String {
        let oldText = self as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
        var newTextString = newText
        
        let digits = NSCharacterSet.decimalDigits
        var digitText = ""
        for c in newTextString.unicodeScalars {
            if digits.contains(c) {
                digitText += "\(c)"
            }
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = Locale(identifier: "pt_BR")
        
        let numberFromField = (NSString(string: digitText).doubleValue)/100
        if let formattedText = formatter.string(for: numberFromField) {
            return formattedText
        }
        return ""
    }
    
    func getCurrencyDouble() -> Double? {
        return Double(self.replacingOccurrences(of: "R$", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "%", with: ""))
    }
    
    func getCurrencyString() -> String {
        return self.replacingOccurrences(of: "R$", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "")
    }
    
    func formatToLocalCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = Locale(identifier: "pt_BR")
        
        if let value = Double(self) {
            if let formattedText = formatter.string(for: value) {
                return formattedText.replacingOccurrences(of: "R$", with: "")
            }
        }
        
        return self
    }
    
    func formatToCurrencyReal() -> String {
        let currency = self.formatToLocalCurrency()
        
        return "R$ \(currency)"
    }
    func formatToCurrencyPoint() -> String {
        let currency = self.formatToLocalCurrency()
        
        return "\(currency)"
    }
    
    func formatToLocalCurrency(with fractionDigits : Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.minimumFractionDigits = fractionDigits
        
        if let value = Double(self) {
            if let formattedText = formatter.string(for: value) {
                return formattedText.replacingOccurrences(of: "R$", with: "")
            }
        }
        
        return self
    }
    
    func jsonObject() -> Any? {
        if let data = self.data(using: .utf8) {
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                return object
            } catch {
            }
        }
        
        return nil
    }

    func dateFormatted() -> String {
        var formatted = self
        if formatted.contains("T") {
            let parts = formatted.components(separatedBy: "T")
            if let isoDateStr = parts.first, let date = Date(fromString: isoDateStr, format: .isoDate) {
                formatted = date.toString(format: .custom(Constants.shared.defaultDateFormat))
            }
        }
        return formatted
    }

    func validateDate() -> Bool {
        let count = Constants.shared.defaultDateFormat.count
        if self.count != count { return false }
        guard let _ = Date(fromString: self, format: .custom(Constants.shared.defaultDateFormat)) else { return false }
        return true
    }
    
    //Validate Email
    func isEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    //validate PhoneNumber
    func isPhoneNumber() -> Bool {
        let character  = CharacterSet(charactersIn: "+0123456789").inverted
        var filtered : String!
        let inputString = self.components(separatedBy: character)
        filtered = inputString.joined(separator: "")
        return self == filtered
    }
    
    //validate CardNumber
    func isCardNumber() -> Bool {
        let character  = CharacterSet(charactersIn: "0123456789").inverted
        var filtered : String!
        let inputString = self.components(separatedBy: character)
        filtered = inputString.joined(separator: "")
        return filtered.count == 16
    }
    
    var isEmptyOrWhitespace: Bool {
        if self.isEmpty || self == "" {
            return true
        }
        return self.trimmingCharacters(in: CharacterSet.whitespaces) == ""
    }
    
    func isCPFValid() -> (value:Bool, message:String) {
        let cpf = self.replacingOccurrences(of: "[^0-9]", with: "", options: String.CompareOptions.regularExpression, range: nil)
        
        if cpf.isEmptyOrWhitespace {
            return (false, "CPF VAZIO.")
        }
        
        var firstSum, secondSum, firstDigit, secondDigit, firstDigitCheck, secondDigitCheck : Int
        
        if NSString(string: cpf).length != 11 {
            return (false, "CPF INVÁLIDO.")
        }
        
        if ((cpf == "00000000000") || (cpf == "11111111111") || (cpf == "22222222222") || (cpf == "33333333333") || (cpf == "44444444444") || (cpf == "55555555555") || (cpf == "66666666666") || (cpf == "77777777777") || (cpf == "88888888888") || (cpf == "99999999999")) {
            return (false, "CPF INVÁLIDO.")
        }
        
        let stringCpf = NSString(string: cpf)
        
        firstSum = 0
        for i in 0...8 {
            firstSum += NSString(string:stringCpf.substring(with: NSMakeRange(i, 1))).integerValue * (10 - i)
        }
        
        if firstSum % 11 < 2 {
            firstDigit = 0
        } else {
            firstDigit = 11 - (firstSum % 11)
        }
        
        secondSum = 0
        for i in 0...9 {
            secondSum += NSString(string:stringCpf.substring(with: NSMakeRange(i, 1))).integerValue * (11 - i)
        }
        
        if secondSum % 11 < 2 {
            secondDigit = 0
        } else {
            secondDigit = 11 - (secondSum % 11)
        }
        
        firstDigitCheck = NSString(string:stringCpf.substring(with: NSMakeRange(9, 1))).integerValue
        secondDigitCheck = NSString(string:stringCpf.substring(with: NSMakeRange(10, 1))).integerValue
        
        if ((firstDigit == firstDigitCheck) && (secondDigit == secondDigitCheck)) {
            return (true, "")
        }
        return (false, "CPF INVÁLIDO.")
    }
    
    func isPasswordValid(minimumDigits: Int = 0, maximumDigits: Int = 30) -> Bool {
        if self == "" || self.count < minimumDigits || self.count > maximumDigits {
            return false
        }
        
        let letters = CharacterSet.letters
        let digits = CharacterSet.decimalDigits
        
        var hasLetter = false
        var hasDigit = false
        
        for character in self.unicodeScalars {
            if letters.contains(character) {
                hasLetter = true
            } else if digits.contains(character) {
                hasDigit = true
            }
        }
        
        if hasLetter && hasDigit {
            return true
        }
        
        return false
    }
    
    func insert(_ string:String,ind:Int) -> String {
        return  String(self.prefix(ind)) + string + String(self.suffix(self.count-ind))
    }
    
    func cpfFormatted() -> String {
        if self.isCPFValid().value {
            var string = self.onlyNumbers()
            
            string.insert(".", at: string.index(string.startIndex, offsetBy: 3))
            string.insert(".", at: string.index(string.startIndex, offsetBy: 7))
            string.insert("-", at: string.index(string.startIndex, offsetBy: 11))
            
            return string
        }
        
        return self
    }

    func phoneFormatted() -> String {
        if self.count == 11 { return self.insert("(", ind: 0).insert(")", ind: 3).insert("-", ind: 9) }
        if self.count == 10 { return self.insert("(", ind: 0).insert(")", ind: 3).insert("-", ind: 8) }
        if self.count == 9 { return self.insert("-", ind: 5) }
        if self.count == 8 { return self.insert("-", ind: 4) }
        if self.count < 8 && self.count > 1 { return self.insert("(", ind: 0).insert(")", ind: 3) }
        return self
    }
    
    func onlyNumbers() -> String {
        return self.replacingOccurrences(of: "[^0-9]", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    
    func maskAgencyAccount(max: Int) -> String {
        var string = self
        if string.count > 0 && string.count-1 < max {
            string = string.replacingOccurrences(of: "-", with: "", options: .backwards, range: nil)
            let str : NSMutableString = NSMutableString(string: string)
            str.insert("-", at: string.count-1)
            return str as String
        }
        
        return string
    }
    
    var width : CGFloat {
        get {
            let label = UILabel()
            
            label.text = self
            
            label.sizeToFit()
            
            if label.frame.width < 50 {
                return 50
            }
            return label.frame.width
        }
        set {
            
        }
    }
    
    var height : CGFloat {
        get {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIApplication.shared.keyWindow!.frame.size.width, height: 40))
            
            label.numberOfLines = 1000
            label.text = self
            
            label.sizeToFit()
            
            return label.frame.height
        }
        set {
            
        }
    }
    
    func substring(to position: Int, isLiteral: Bool = true) -> String {
        if !isEmptyOrWhitespace && count >= position {
            return "\(substring(to: index(startIndex, offsetBy: position)))\(isLiteral ? "" : "...")"
        }
        
        return self
    }
    
    func substring(from position: Int, isLiteral: Bool = true) -> String {
        if !isEmptyOrWhitespace && count >= position {
            return "\(substring(from: index(endIndex, offsetBy: position - count)))\(isLiteral ? "" : "...")"
        }
        
        return self
    }
    
    static var randomPassword: String {
        let passwordCharacters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")
        let len = 8
        var password = ""
        for _ in 0..<len {
            let rand = arc4random_uniform(UInt32(passwordCharacters.count))
            password.append(passwordCharacters[Int(rand)])
        }
        return password
    }
    
    var cleanNumber: String {
        if let value = self.getCurrencyDouble() {
            return String(format: "%.0f", value)
        }
        return self
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Float {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
    var clean: String {
        return String(format: "%.0f", self)
    }
}

extension Double {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
    var clean: String {
        return String(format: "%.0f", self)
    }
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
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
        guard let container = superview else { return }
        
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

extension NSAttributedString {
    static func strikedText(_ text: String, color : UIColor) -> NSAttributedString {
        let textAttributes = [
            NSAttributedStringKey.foregroundColor: color,
            NSAttributedStringKey.strikethroughStyle: 1
            ] as [NSAttributedStringKey : Any]
        
        return NSAttributedString(string: text, attributes: textAttributes)
    }
    
    static func strokeText(_ text: String, color : UIColor, strokeColor : UIColor) -> NSAttributedString {
        let textAttributes = [
            NSAttributedStringKey.foregroundColor: color,
            NSAttributedStringKey.strokeColor: strokeColor,
            NSAttributedStringKey.strokeWidth: 1.0
            ] as [NSAttributedStringKey : Any]
        
        return NSAttributedString(string: text, attributes: textAttributes)
    }
}

extension Array {
    mutating func shuffle () {
        for i in (0..<self.count).reversed() {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    }
    
    var shuffled: Array {
        var array = self
        array.shuffle()
        return array
    }
    
    func added(_ element: Element) -> Array {
        var array = self
        array.append(element)
        return array
    }
}

extension Array {
    func contains(_ object : AnyObject) -> Bool {
        if self.isEmpty {
            return false
        }
        
        let array = NSArray(array: self)
        
        return array.contains(object)
    }
    
    func index(of object : AnyObject) -> Int? {
        if self.contains(object) {
            let array = NSArray(array: self)
            
            return array.index(of: object)
        }
        
        return nil
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

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UITableView {
    func dequeueReusableCell<T:UITableViewCell>(indexPath: IndexPath) -> T where T:ReusableView {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Cant dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

protocol ReusableView : class { }

extension ReusableView where Self:UIView {
    static var reuseIdentifier : String {
        return String(describing:self)
    }
}

protocol ReusableIdentifier : class { }

extension ReusableIdentifier where Self:UIViewController {
    static var identifier : String {
        return String(describing:self)
    }
}

extension UIViewController: ReusableIdentifier {
}

extension UITabBarController {
    func setTabBarVisible(visible: Bool, animated: Bool) {
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }
    }
}

extension UIAlertController {
    func presentAnywhere() {
        UIAlertController.getTopViewController().present(self, animated: true, completion: nil)
    }
    
    static func getTopViewController() -> UIViewController {
        var viewController = UIViewController()
        if let vc =  UIApplication.shared.delegate?.window??.rootViewController {
            viewController = vc
            var presented = vc
            while let top = presented.presentedViewController {
                presented = top
                viewController = top
            }
        }
        return viewController
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
