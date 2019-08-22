//
//  LocationService.swift
//  mapsApp
//
//  Created by Carles Cañades Torrents on 22/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import CoreLocation
import UIKit

class LocationService: NSObject {

    // MARK: - Fields

    private let locationManager = CLLocationManager()
    private let alertDialogService = AlertDialogService.sharedInstance

    // MARK: Constructor

    public override init() {
        super.init()

        self.setup()
    }

    // MARK: - Accessible Methods

    func setLocationManagerDelegate(delegate: CLLocationManagerDelegate?) {
        locationManager.delegate = delegate
    }

    // MARK: - Helpers
    
    private func setup() {
        setupLocation()
    }
    

    private func setupLocation() {
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            requestAuthorization()
        case .notDetermined:
            // For use when the app is open & in the background
            //locationManager.requestAlwaysAuthorization()
            
            // For use when the app is open
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    private func startTrackingUserLocation() {
        
        //it starts the didUpdateLocations function in delegate
        locationManager.startUpdatingLocation()
    }

    private func requestAuthorization() {
        self.alertDialogService.showAlert(title: "",
                                          message: "change_location_settings",
                                          btAcceptText: "open_settings",
                                          btCancelText: "cancel",
                                          btAcceptCompletion: {
                                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                            }
        })
    }
}
