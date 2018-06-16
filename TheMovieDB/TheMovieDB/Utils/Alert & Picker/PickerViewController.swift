//
//  PickerViewController.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

extension UIAlertController {
    func addPickerView(values: PickerViewController.Values,
                       initialSelection: PickerViewController.Index? = nil,
                       action: PickerViewController.Action?) {
        
        let pickerView = PickerViewController(values: values, initialSelection: initialSelection, action: action)
        set(viewController: pickerView, height: 216)
    }
}

class PickerViewController: UIViewController {
    typealias Values = [[String]]
    typealias Index = (column: Int, row: Int)
    typealias Action = (_ viewController: UIViewController, _ picker: UIPickerView, _ index: Index, _ values: Values) -> ()
    
    private var action: Action?
    private var values: Values = [[]]
    private var initialSelection: Index?
    
    private lazy var pickerView: UIPickerView = {
        return $0
    }(UIPickerView())
    
    init(values: Values, initialSelection: Index? = nil, action: Action?) {
        super.init(nibName: nil, bundle: nil)
        self.values = values
        self.initialSelection = initialSelection
        self.action = action
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    override func loadView() {
        view = pickerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let initialSelection = initialSelection, values.count > initialSelection.column, values[initialSelection.column].count > initialSelection.row else {
            return
        }
        
        pickerView.selectRow(initialSelection.row, inComponent: initialSelection.column, animated: true)
    }
}

extension PickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return values.count
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values[component].count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[component][row]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        action?(self, pickerView, Index(column: component, row: row), values)
    }
}
