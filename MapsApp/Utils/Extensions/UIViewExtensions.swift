//
//  UIViewExtensions.swift
//  mapsApp
//
//  Created by Carles Cañades Torrents on 14/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            //statusBar.backgroundColor = style == .lightContent ? UIColor.black : .white
            statusBar.setValue(style == .lightContent ? UIColor.white : .black, forKey: "foregroundColor")
        }
    }
}


extension UIView {
    func fixInView(_ container: UIView!) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading,
                           relatedBy: .equal, toItem: container,
                           attribute: .leading, multiplier: 1.0,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing,
                           relatedBy: .equal, toItem: container,
                           attribute: .trailing, multiplier: 1.0,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top,
                           relatedBy: .equal, toItem: container,
                           attribute: .top, multiplier: 1.0,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom,
                           relatedBy: .equal, toItem: container,
                           attribute: .bottom, multiplier: 1.0,
                           constant: 0).isActive = true
    }
}
