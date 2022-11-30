//
//  UIViewController.swift
//  Currency
//
//  Created by murad on 29/11/2022.
//

import UIKit
extension UIViewController {

func showToast(message : String, font: UIFont) {

    DispatchQueue.main.async {
        let toastLabel = UILabel(frame: .zero)
        toastLabel.backgroundColor = UIColor.red
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        toastLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        toastLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 100).isActive = true
        UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
} }
