//
//  GMViewController.swift
//  mapsApp
//
//  Created by Carles Cañades Torrents on 21/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class GMViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var mapView: GMSMapView!

    // MARK: - Fields

    private let locationManager = CLLocationManager()

    // MARK: - Constructor

    // MARK: - Life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        
   
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - Helpers
}

extension GMViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        guard status == .authorizedWhenInUse else {
            return
        }

        locationManager.startUpdatingLocation()

        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else {
            return
        }

        mapView.camera = GMSCameraPosition(target: location.coordinate,
                                           zoom: 15,
                                           bearing: .zero,
                                           viewingAngle: .zero)

        locationManager.stopUpdatingLocation()
    }
}

extension MapViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        //reverseGeocodeCoordinate(position.target)
    }

}
