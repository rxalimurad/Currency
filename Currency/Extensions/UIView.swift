//
//  UIView.swift
//  Currency
//
//  Created by murad on 28/10/2022.
//

import UIKit
// MARK: - Styling
@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
}
// MARK: - Contrainst
extension UIView {
    func setContraints(with view: UIView) {
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}
// MARK: - Animation
extension UIView {
    func toggleView(isShowing: Bool) {
        self.isHidden = !isShowing
    }
}
