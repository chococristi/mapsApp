//
//  UIButtonExtensions.swift
//  mapsApp
//
//  Created by Carles Cañades Torrents on 28/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import Foundation

import Foundation

extension UIButton {

    // MARK: - Helpers

    func setBackgroundColor(_ color: UIColor,
                            for state: UIControl.State) {

        self.setBackgroundImage(nil,
                                for: state)
        self.setBackgroundImage(image(withColor: color),
                                for: state)
    }

    private func image(withColor color: UIColor) -> UIImage? {

        let colorImage = UIGraphicsImageRenderer(size: self.bounds.size).image { _ in
            color.setFill()
            UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).fill()
        }

        return colorImage
    }
}
