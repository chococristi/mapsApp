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

    private var locationService: LocationService?
    private var markers: Markers?
    // MARK: - Constructor

    // MARK: - Life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        locationService = LocationService()

        setup()
    }

    // MARK: - Helpers

    func setup() {
        initializeLocationManager()
        setupMap()
    }

    func initializeLocationManager() {

        guard let locationService = locationService else {
            return
        }

        locationService.setLocationManagerDelegate(delegate: self)
    }

    func setupMap() {
        guard let path = Bundle.main.path(forResource: "bcnlocations", ofType: "json") else {
            return
        }

        let fileUrl = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: fileUrl)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)

            guard let array = json as? [String: Any] else { return }
            self.markers = Markers.init(json: array)
            setAnnotationsInMap()
        } catch {
            print(error)
        }
    }

    fileprivate func setAnnotationsInMap() {

        guard let markersArray = markers?.markers else {
            return
        }

        for marker in markersArray {
            //TODO first / last i'm not sure if can be done better
            guard let latitude = marker.coordinates.first,
                let longitude = marker.coordinates.last else {
                return
            }

            let position = CLLocationCoordinate2DMake(latitude, longitude)
            let gmsMarker = GMSMarker(position: position)
            gmsMarker.title = marker.name
            gmsMarker.map = mapView
        }
    }

}

extension GMViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        guard status == .authorizedWhenInUse else {
            return
        }

        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        cameraMoveToLocation(toLocation: manager.location?.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else {
            return
        }

        cameraMoveToLocation(toLocation: location.coordinate)

        //locationManager.stopUpdatingLocation()
    }
}

extension GMViewController {

    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {

        guard let location = toLocation else {
            return
        }

        mapView.camera = GMSCameraPosition(target: location,
                                           zoom: 15,
                                           bearing: .zero,
                                           viewingAngle: .zero)
    }

}
