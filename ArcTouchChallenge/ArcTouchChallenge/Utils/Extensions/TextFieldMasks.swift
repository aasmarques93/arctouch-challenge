//
//  TextFieldPhoneMask.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Bond

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class TextFieldPhoneMask: TextField, TextFieldMaskDelegate {
    override func awakeFromNib() {
        isNumberText = true
        
        super.awakeFromNib()
        keyboardType = .phonePad
        textFieldMaskDelegate = self
    }
    
    func shouldChange(_ textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        var appendString = ""
        
        if range.length == 0 {
            switch range.location {
            case 0: appendString = "("
            case 3: appendString = ") "
            case 9: appendString = "-"
            default: break
            }
        }
        
        if text?.count == 15 {
            if range.length == 1 {
                var tel = self.text
                tel = tel?.replacingOccurrences(of: "-", with: "")
                tel = tel?.insert("-", ind: 9)
                self.text = tel
            }
        }
        
        if text?.count == 14 {
            if range.length == 0 {
                var tel = self.text
                tel = tel?.replacingOccurrences(of: "-", with: "")
                tel = tel?.insert("-", ind: 10)
                self.text = tel
            }
        }
        
        text?.append(appendString)
        if text?.count > 14 && range.length == 0 { return false }
        
        return true
    }
}

class TextFieldDigitableDateMask: TextField, TextFieldMaskDelegate {
    override func awakeFromNib() {
        isNumberText = true
        super.awakeFromNib()
        keyboardType = .numberPad
        textFieldMaskDelegate = self
    }

    func shouldChange(_ textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        var appendString = ""
        if range.length == 0 {
            switch range.location {
            case 2: appendString = "/"
            case 5: appendString = "/"
            default: break
            }
        }

        text?.append(appendString)
        if text?.count > 9 && range.length == 0 { return false }
        return true
    }
}

class TextFieldCPFMask: TextField, TextFieldMaskDelegate {
    override func awakeFromNib() {
        isNumberText = true
        super.awakeFromNib()
        keyboardType = .numberPad
        textFieldMaskDelegate = self
    }
    
    func shouldChange(_ textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        var appendString = ""
        
        if range.length == 0 {
            switch range.location {
            case 3: appendString = "."
            case 7: appendString = "."
            case 11: appendString = "-"
            default: break
            }
        }
        
        text?.append(appendString)
        if text?.count > 13 && range.length == 0 { return false }
        return true
    }
}

class TextFieldRGMask: TextField, TextFieldMaskDelegate {
    override func awakeFromNib() {
        isNumberText = true
        super.awakeFromNib()
        keyboardType = .numberPad
        textFieldMaskDelegate = self
    }
    
    func shouldChange(_ textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        var appendString = ""
        
        if range.length == 0 {
            switch range.location {
            case 1: appendString = "."
            case 5: appendString = "."
            default: break
            }
        }
        
        text?.append(appendString)
        if text?.count > 9 && range.length == 0 { return false }
        return true
    }
}

protocol TextFieldCEPDelegate: class {
    func didSelect(cep: String?)
}

class TextFieldCEPMask: TextField, TextFieldMaskDelegate {
    weak var cepDelegate: TextFieldCEPDelegate?
    
    override func awakeFromNib() {
        isNumberText = true
        super.awakeFromNib()
        keyboardType = .numberPad
        textFieldMaskDelegate = self
    }
    
    func shouldChange(_ textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        var appendString = ""
        
        if range.length == 0 {
            switch range.location {
            case 2: appendString = "."
            case 6: appendString = "-"
            default: break
            }
        }
        
        text?.append(appendString)
        if text?.count > 9 && range.length == 0 { return false }
        return true
    }
    
    func didEndEditing(_ textField: UITextField) {
        cepDelegate?.didSelect(cep: textField.text)
    }
}

class TextFieldBankMask: TextField, TextFieldMaskDelegate {
    @IBInspectable var maxCharacteres = 5
    @IBInspectable var isDigitAvaiable = true
    
    override func awakeFromNib() {
        isNumberText = true
        super.awakeFromNib()
        keyboardType = .numberPad
        textFieldMaskDelegate = self
    }
    
    func shouldChange(_ textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            if isDigitAvaiable { text = text?.maskAgencyAccount(max: maxCharacteres) }
            if text!.count == maxCharacteres-1 { text = "\(text!)\(string)" }
            if text!.count > maxCharacteres-1 { return false }
        }
        return true
    }
}

class TextFieldCurrencyMask: TextField, TextFieldMaskDelegate {
    @IBInspectable var isRealVisible = true
    
    override func awakeFromNib() {
        isNumberText = true
        super.awakeFromNib()
        keyboardType = .numberPad
        textFieldMaskDelegate = self
    }
    
    func shouldChange(_ textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            text = text!.formatCurrency(range: range, string: string)
            if isRealVisible {
                text = "R$ \(text!.replacingOccurrences(of: "R$", with: ""))"
            } else {
                text = text!.replacingOccurrences(of: "R$", with: "")
            }
            return false
        }
        return true
    }
}

class TextFieldCardNumberMask: TextField, TextFieldMaskDelegate {
    override func awakeFromNib() {
        isNumberText = true
        super.awakeFromNib()
        keyboardType = .numberPad
        textFieldMaskDelegate = self
    }
    
    func shouldChange(_ textField: UITextField, range: NSRange, replacementString string: String) -> Bool {
        var appendString = ""
        
        if range.length == 0 {
            switch range.location {
            case 4: appendString = "."
            case 9: appendString = "."
            case 14: appendString = "."
            default: break
            }
        }
        
        text?.append(appendString)
        if text?.count > 18 && range.length == 0 { return false }
        return true
    }
}

protocol TextFieldDateDelegate: class {
    func didSelect(textField: TextFieldDateMask, date: Date, string: String?)
}

class TextFieldDateMask: TextField, TextFieldMaskDelegate {
    @IBInspectable var dateFormat: String = Constants.shared.defaultDateFormat
    @IBInspectable var isBirthday: Bool = false
    
    weak var dateDelegate: TextFieldDateDelegate?
    
    let datePicker = UIDatePicker()
    
    override func awakeFromNib() {
        isNumberText = true
        super.awakeFromNib()
        datePicker.date = Date()
        datePicker.datePickerMode = .date
        
        if isBirthday { datePicker.maximumDate = Date() }
        
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        inputView = datePicker
        textFieldMaskDelegate = self
    }
    
    @objc func datePickerChanged() { text = datePicker.date.toString(format: .custom(dateFormat)) }
    func didEndEditing(_ textField: UITextField) {
        text = datePicker.date.toString(format: .custom(dateFormat))
        dateDelegate?.didSelect(textField: self, date: datePicker.date, string: text)
    }
}

enum Sexo: Int {
    case masculino = 1
    case feminino = 2
    
    static func enumValue(for string: String) -> Int {
        if string == Sexo.feminino.string { return Sexo.feminino.rawValue }
        return Sexo.masculino.rawValue
    }
    
    static func enumValue(for number: Int) -> Sexo {
        if number == Sexo.feminino.rawValue { return .feminino }
        return .masculino
    }
    
    var string: String {
        return String(describing: self)
    }
}

protocol TextFieldSexoDelegate: class {
    func didSelect(sexo: Sexo)
}

class TextFieldSexoMask: TextField, TextFieldMaskDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    weak var sexoDelegate: TextFieldSexoDelegate?
    
    let pickerView = UIPickerView()
    
    var sexo: Sexo = .masculino
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.dataSource = self
        textFieldMaskDelegate = self
        inputView = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Sexo(rawValue: row)?.string
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let value = Sexo(rawValue: row) { sexo = value }
        text = Sexo(rawValue: row)?.string
    }
    func select(sexo: Sexo) {
        text = sexo.string
        sexoDelegate?.didSelect(sexo: sexo)
    }
    func didEndEditing(_ textField: UITextField) {
        text = sexo.string
        sexoDelegate?.didSelect(sexo: sexo)
    }
}

enum EstadoCivil: Int {
    case solteiro = 1
    case casado = 2
    case divorciado = 3
    case viuvo = 4
    case separado = 5
    
    static func enumValue(for string: String) -> Int {
        if string == EstadoCivil.casado.string { return EstadoCivil.casado.rawValue }
        if string == EstadoCivil.divorciado.string { return EstadoCivil.divorciado.rawValue }
        if string == EstadoCivil.viuvo.string { return EstadoCivil.viuvo.rawValue }
        if string == EstadoCivil.separado.string { return EstadoCivil.separado.rawValue }
        
        return EstadoCivil.solteiro.rawValue
    }
    
    static func enumValue(for number: Int) -> EstadoCivil {
        if number == EstadoCivil.casado.rawValue { return .casado }
        if number == EstadoCivil.divorciado.rawValue { return .divorciado }
        if number == EstadoCivil.viuvo.rawValue { return .viuvo }
        if number == EstadoCivil.separado.rawValue { return .separado }
        return .solteiro
    }
    
    var string: String {
        return "\(String(describing: self))(a)"
    }
}

protocol TextFieldEstadoCivilDelegate: class {
    func didSelect(estadoCivil: EstadoCivil)
}

class TextFieldEstadoCivilMask: TextField, TextFieldMaskDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    weak var estadoCivilDelegate: TextFieldEstadoCivilDelegate?
    
    let pickerView = UIPickerView()
    
    var estadoCivil: EstadoCivil = .solteiro
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.dataSource = self
        textFieldMaskDelegate = self
        inputView = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return EstadoCivil(rawValue: row)?.string
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let value = EstadoCivil(rawValue: row) { estadoCivil = value }
        text = EstadoCivil(rawValue: row)?.string
    }
    func select(estadoCivil: EstadoCivil) {
        text = estadoCivil.string
        estadoCivilDelegate?.didSelect(estadoCivil: estadoCivil)
    }
    func didEndEditing(_ textField: UITextField) {
        text = estadoCivil.string
        estadoCivilDelegate?.didSelect(estadoCivil: estadoCivil)
    }
}

@objc protocol TextFieldMaskDelegate {
    @objc optional func didBeginEditing(_ textField: UITextField)
    @objc optional func didEndEditing(_ textField: UITextField)
    @objc optional func shouldReturn(_ textField: UITextField) -> Bool
    @objc optional func shouldChange(_ textField: UITextField, range: NSRange, replacementString string: String) -> Bool
}

