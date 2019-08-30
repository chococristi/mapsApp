//
//  UIStoryboardExtensions.swift
//  mapsApp
//
//  Created by Carles Cañades Torrents on 23/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }

    static func leftViewController() -> LeftViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LeftViewController") as? LeftViewController
    }

    static func rightViewController() -> RightViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "RightViewController") as? RightViewController
    }

    static func centerViewController() -> MainViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
    }

    static func mapStoryboard() -> UIStoryboard { return UIStoryboard(name: "map", bundle: Bundle.main) }

    static func mapViewController() -> MapViewController? {
        return mapStoryboard().instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
    }

    static func carsListViewController() -> CarsListViewController? {
        return mapStoryboard().instantiateViewController(withIdentifier: "CarsListViewController") as? CarsListViewController
    }
}
