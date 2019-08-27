//
//  UIPanGestureExtension.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 14/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import Foundation
import UIKit

extension UIPanGestureRecognizer {

    enum GestureDirection {
        case upper
        case down
        case left
        case right
    }

    /// Get current vertical direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func verticalDirection(target: UIView) -> GestureDirection {
        return self.velocity(in: target).y > 0 ? .down : .upper
    }

    /// Get current horizontal direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func horizontalDirection(target: UIView) -> GestureDirection {
        return self.velocity(in: target).x > 0 ? .right : .left
    }

    /// Get a tuple for current horizontal/vertical direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func versus(target: UIView) -> (horizontal: GestureDirection, vertical: GestureDirection) {
        return (self.horizontalDirection(target: target), self.verticalDirection(target: target))
    }

}
