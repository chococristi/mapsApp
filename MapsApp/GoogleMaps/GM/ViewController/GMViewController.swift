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

//https://developers.google.com/maps/documentation/ios-sdk/utility/marker-clustering
//https://github.com/googlemaps/google-maps-ios-utils/blob/master/Swift.md

class GMViewController: UIViewController, GMUClusterManagerDelegate, GMSMapViewDelegate {

    // MARK: - IBOutlets

    @IBOutlet weak var mapView: GMSMapView!

    // MARK: - Fields

    private var locationService: LocationService?
    private var markers: Markers?
    //private var poiMarkers: POIMarkers?
    private var clusterManager: GMUClusterManager!

    // MARK: - Constructor

    // MARK: - Life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        locationService = LocationService()

        setup()
    }

    // MARK: - Helpers

    func setup() {
        initializeLocationManager()
        //setupMap()

        //setAnnotationsInMap()
        //setRouteInMap()   //We need to pay for route
        setupCluster()
    }

    func initializeLocationManager() {

        guard let locationService = locationService else {
            return
        }

        locationService.setLocationManagerDelegate(delegate: self)
    }

    func setupMap() {
        guard let path = Bundle.main.path(forResource: "bcnlocations",
                                          ofType: "json") else {
            return
        }

        let fileUrl = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: fileUrl)
            let json = try JSONSerialization.jsonObject(with: data,
                                                        options: .mutableContainers)

            guard let array = json as? [String: Any] else { return }
            self.markers = Markers.init(json: array)
        } catch {
            print(error)
        }
    }

    fileprivate func setAnnotationsInMap() {

        guard let markersArray = markers?.markers else {
            return
        }

        for marker in markersArray {
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

    fileprivate func setRouteInMap() {

        guard let markersArray = markers?.markers else {
            return
        }

        let marker = markersArray[0]
        let marker2 = markersArray[1]

        guard let latitude = marker.coordinates.first,
            let longitude = marker.coordinates.last else {
                return
        }

        guard let latitude2 = marker2.coordinates.first,
            let longitude2 = marker2.coordinates.last else {
                return
        }

        let position = CLLocationCoordinate2DMake(latitude, longitude)
        let position2 = CLLocationCoordinate2DMake(latitude2, longitude2)

        mapView.drawPolygon(from: position, to: position2)

    }

    func setupCluster() {
        // Set up the cluster manager with the supplied icon generator and
        // renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView,
                                           algorithm: algorithm,
                                           renderer: renderer)

        // Generate and add items to the cluster manager.
        setupPOIMarkers()
        // Call cluster() after items have been added to perform the clustering
        // and rendering on map.
        clusterManager.cluster()
    }

    func setupPOIMarkers() {
        guard let path = Bundle.main.path(forResource: "BcnMarkers",
                                          ofType: "json") else {
                                            return
        }

        let fileUrl = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: fileUrl)
            let json = try JSONSerialization.jsonObject(with: data,
                                                        options: .mutableContainers)

            guard let array = json as? [String: Any],
                let poiMarkers = POIMarkers.init(json: array) else { return }

            for item in poiMarkers.poiMarkers {
                clusterManager.add(item)
            }

        } catch {
            print(error)
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

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        guard let location = locations.first else {
//            return
//        }
//
//        cameraMoveToLocation(toLocation: location.coordinate)
//
//    }
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
