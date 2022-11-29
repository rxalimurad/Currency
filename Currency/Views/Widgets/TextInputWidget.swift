//
//  TextInputWidget.swift
//  Currency
//
//  Created by murad on 28/10/2022.
//

import UIKit


class TextInputWidget: UITextField {
    // MARK: - Properties
    let hintColor: UIColor = .lightGray
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    // MARK: - Intializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setHintColor(color: hintColor)
        self.inputAccessoryView = getToolbar()
    }
    
    // MARK: - Methods
    func setHintColor(color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(
            string: self.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
    func getToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    @objc
    func donePicker() {
        self.resignFirstResponder()
    }
    // MARK: - Overrides
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
