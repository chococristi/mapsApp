//
//  CurvedView.swift
//  mapsApp
//
//  Created by Carles Cañades Torrents on 13/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit

/** This is a view which has it's top left and right corners rounded.
 */
class CurvedView: UIView {

    let cornerRadius: CGFloat = 24.0

    override func layoutSubviews() {
        super.layoutSubviews()
        setMask()

    }

    // Sets a mask on the view to round it's corners
    func setMask() {
        backgroundColor = .clear

        let maskPath = UIBezierPath(roundedRect:self.bounds,
                                    byRoundingCorners: [.topLeft,
                                                        .topRight],
                                    cornerRadii: CGSize(width: cornerRadius,
                                                        height: cornerRadius))

//        let shape = CAShapeLayer()
//        shape.path = maskPath.cgPath
//        self.layer.mask = shape

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        shape.fillColor = UIColor.white.cgColor
        shape.shadowColor = UIColor.black.cgColor
        shape.shadowPath = shape.path
        shape.shadowOffset = CGSize(width: 0.0, height: 5.0)
        shape.shadowOpacity = 0.5
        shape.shadowRadius = 5
        layer.insertSublayer(shape, at: 0)
    }
}
