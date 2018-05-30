//
//  String.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/4/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

extension String {
    func formatCurrency(range: NSRange, string: String) -> String {
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
        formatter.locale = Locale.current
        
        let numberFromField = (NSString(string: digitText).doubleValue)/100
        if let formattedText = formatter.string(for: numberFromField) {
            return formattedText
        }
        return ""
    }
    
    var jsonObject: Any? {
        if let data = self.data(using: .utf8) {
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                return object
            } catch { }
        }
        return nil
    }
    
    var dateFormatted: String {
        var formatted = self
        if formatted.contains("T") {
            let parts = formatted.components(separatedBy: "T")
            if let isoDateStr = parts.first, let date = Date(fromString: isoDateStr, format: .isoDate) {
                formatted = date.toString(format: .custom(Constants.defaultDateFormat))
            }
        }
        return formatted
    }
    
    var idDateValid: Bool {
        let count = Constants.defaultDateFormat.count
        if self.count != count { return false }
        guard let _ = Date(fromString: self, format: .custom(Constants.defaultDateFormat)) else {
            return false
        }
        return true
    }
    
    // Validate Email
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    // validate PhoneNumber
    var isPhoneNumber: Bool {
        let character  = CharacterSet(charactersIn: "+0123456789").inverted
        var filtered: String!
        let inputString = self.components(separatedBy: character)
        filtered = inputString.joined(separator: "")
        return self == filtered
    }
    
    // validate CardNumber
    var isCardNumber: Bool {
        let character  = CharacterSet(charactersIn: "0123456789").inverted
        var filtered: String!
        let inputString = self.components(separatedBy: character)
        filtered = inputString.joined(separator: "")
        return filtered.count == 16
    }
    
    var isEmptyOrWhitespace: Bool {
        if self.isEmpty || self == "" { return true }
        return self.trimmingCharacters(in: CharacterSet.whitespaces) == ""
    }
    
    func isRegisterIdValid() -> (value:Bool, message:String) {
        let registerId = self.replacingOccurrences(of: "[^0-9]", with: "", options: String.CompareOptions.regularExpression, range: nil)
        
        if registerId.isEmptyOrWhitespace {
            return (false, "Empty.")
        }
        
        var firstSum, secondSum, firstDigit, secondDigit, firstDigitCheck, secondDigitCheck: Int
        
        if NSString(string: registerId).length != 11 {
            return (false, "Invalid.")
        }
        
        if ((registerId == "00000000000") || (registerId == "11111111111") || (registerId == "22222222222") || (registerId == "33333333333") || (registerId == "44444444444") || (registerId == "55555555555") || (registerId == "66666666666") || (registerId == "77777777777") || (registerId == "88888888888") || (registerId == "99999999999")) {
            return (false, "Invalid.")
        }
        
        let stringRegisterId = NSString(string: registerId)
        
        firstSum = 0
        for i in 0...8 {
            firstSum += NSString(string:stringRegisterId.substring(with: NSMakeRange(i, 1))).integerValue * (10 - i)
        }
        
        if firstSum % 11 < 2 {
            firstDigit = 0
        } else {
            firstDigit = 11 - (firstSum % 11)
        }
        
        secondSum = 0
        for i in 0...9 {
            secondSum += NSString(string:stringRegisterId.substring(with: NSMakeRange(i, 1))).integerValue * (11 - i)
        }
        
        if secondSum % 11 < 2 {
            secondDigit = 0
        } else {
            secondDigit = 11 - (secondSum % 11)
        }
        
        firstDigitCheck = NSString(string:stringRegisterId.substring(with: NSMakeRange(9, 1))).integerValue
        secondDigitCheck = NSString(string:stringRegisterId.substring(with: NSMakeRange(10, 1))).integerValue
        
        if ((firstDigit == firstDigitCheck) && (secondDigit == secondDigitCheck)) {
            return (true, "")
        }
        return (false, "Invalid.")
    }
    
    func isPasswordValid(minimumDigits: Int = 0, maximumDigits: Int = 30, isComplexPasswordRequired: Bool = true) -> Bool {
        if self == "" || self.count < minimumDigits || self.count > maximumDigits {
            return false
        }
        
        if !isComplexPasswordRequired { return true }
        
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
        
        return hasLetter && hasDigit
    }
    
    func insert(_ string: String, at index: Int) -> String {
        return String(prefix(index)) + string + String(suffix(count - index))
    }
    
    var registedIdFormatted: String {
        if isRegisterIdValid().value {
            var string = onlyNumbers
            
            string.insert(".", at: string.index(string.startIndex, offsetBy: 3))
            string.insert(".", at: string.index(string.startIndex, offsetBy: 7))
            string.insert("-", at: string.index(string.startIndex, offsetBy: 11))
            
            return string
        }
        
        return self
    }
    
    var phoneFormatted: String {
        if count == 11 { return insert("(", at: 0).insert(")", at: 3).insert("-", at: 9) }
        if count == 10 { return insert("(", at: 0).insert(")", at: 3).insert("-", at: 8) }
        if count == 9 { return insert("-", at: 5) }
        if count == 8 { return insert("-", at: 4) }
        if count < 8 && count > 1 { return insert("(", at: 0).insert(")", at: 3) }
        return self
    }
    
    var onlyNumbers: String {
        return replacingOccurrences(of: "[^0-9]", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    
    func maskAgencyAccount(max: Int) -> String {
        var string = self
        if string.count > 0 && string.count-1 < max {
            string = string.replacingOccurrences(of: "-", with: "", options: .backwards, range: nil)
            let str: NSMutableString = NSMutableString(string: string)
            str.insert("-", at: string.count-1)
            return str as String
        }
        
        return string
    }
    
    var width: CGFloat {
        get {
            let label = UILabel()
            label.text = self
            label.sizeToFit()
            
            if label.frame.width < 50 { return 50 }
            return label.frame.width
        }
        set { }
    }
    
    var height: CGFloat {
        get {
            guard let keyWindow = UIApplication.shared.keyWindow else {
                return 0
            }
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: keyWindow.frame.size.width, height: 40))
            label.numberOfLines = 1000
            label.text = self
            label.sizeToFit()
            return label.frame.height
        }
        set { }
    }
    
    func heightWith(width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        label.numberOfLines = 1000
        label.text = self
        label.sizeToFit()
        return label.frame.height
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

extension NSAttributedString {
    static func strikedText(_ text: String, color: UIColor) -> NSAttributedString {
        let textAttributes = [
            NSAttributedStringKey.foregroundColor: color,
            NSAttributedStringKey.strikethroughStyle: 1
            ] as [NSAttributedStringKey: Any]
        
        return NSAttributedString(string: text, attributes: textAttributes)
    }
    
    static func strokeText(_ text: String, color: UIColor, strokeColor: UIColor) -> NSAttributedString {
        let textAttributes = [
            NSAttributedStringKey.foregroundColor: color,
            NSAttributedStringKey.strokeColor: strokeColor,
            NSAttributedStringKey.strokeWidth: 1.0
            ] as [NSAttributedStringKey: Any]
        
        return NSAttributedString(string: text, attributes: textAttributes)
    }
}
