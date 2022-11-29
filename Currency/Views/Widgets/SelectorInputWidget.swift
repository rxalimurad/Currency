//
//  SelectorInputWidget.swift
//  Currency
//
//  Created by murad on 28/10/2022.
//

import UIKit

class SelectorInputWidget: UITextField {
    // MARK: - dataSource
    var data = [KeyValuePair]()
    
    // MARK: - SubView initalized
    var pickerView = UIPickerView()
    var currentSelectedValue: KeyValuePair?
    
    // MARK: - Design Properties
    let hintColor: UIColor = .lightGray
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 40)
    let rightImageSize: CGFloat = 20
    let horizantalSpacing: CGFloat = 10
    
    // MARK: - Intializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setHintColor(color: hintColor)
        setKeyboardType()
        setDelegates()
        setLeftView()
    }
    // MARK: - Methods
    
    func setHintColor(color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(
            string: self.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
    func setKeyboardType() {
        self.inputView = pickerView
        self.inputAccessoryView = getToolbar()
    }
    func setDelegates() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
    }
    func getToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPicker))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    func setLeftView() {
        let image = UIImage.custom.downArrow
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: rightImageSize, height: rightImageSize))
                    imageView.contentMode = .scaleAspectFit
                    imageView.image = image
        imageView.tintColor = .black
        self.rightView = imageView
        rightViewMode = .always
    }
    
    // MARK: - Actions
    
    @objc
    func donePicker() {
        if currentSelectedValue == nil {
            currentSelectedValue = data.first
        }
        self.text = currentSelectedValue?.value
        self.resignFirstResponder()
    }
    @objc
    func cancelPicker() {
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
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
            var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x += -(padding.right - horizantalSpacing  - rightImageSize)
            return textRect
        }
    
}
// MARK: - Picker View Delegates
extension SelectorInputWidget: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].value 
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentSelectedValue = data[row]
    }

}
