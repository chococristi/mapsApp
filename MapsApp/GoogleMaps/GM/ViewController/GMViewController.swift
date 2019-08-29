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

//https://developers.google.com/maps/documentation/ios-sdk/utility/marker-clustering //Clustering documentation
//https://github.com/googlemaps/google-maps-ios-utils/blob/master/Swift.md 
//https://mapstyle.withgoogle.com //Map styles
//https://stackoverflow.com/questions/38547622/how-to-implement-gmuclusterrenderer-in-swift // cluser style

class GMViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var swMap: SwitchCustom!
    @IBOutlet weak var mapView: GMSMapView!

    // MARK: - Fields

    let nightImage: UIImage? = UIImage.init(named: "nightModeImage")?.withRenderingMode(.alwaysOriginal)
    let dayImage: UIImage? = UIImage.init(named: "dayModeImage")?.withRenderingMode(.alwaysOriginal)

    private var locationService: LocationService?
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
        setupSwitch()

        initializeLocationManager()
        setupMapStyle(isOn: swMap.isOn)

        //setRouteInMap()   //We need to pay for route
        setupCluster()

        //mapView.isTrafficEnabled = true //Show traffic in map, default false
    }

    func setupSwitch() {
        swMap.isOn = false
        swMap.onImage = nightImage
        swMap.offImage = dayImage
        swMap.onTintColor = MapsColors.mainColor
        swMap.offTintColor = MapsColors.mainColor

        swMap.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
    }

    @objc func switchValueDidChange(sender:SwitchCustom!) {
        setupMapStyle(isOn: sender.isOn)
    }

    func initializeLocationManager() {

        guard let locationService = locationService else {
            return
        }

        locationService.setLocationManagerDelegate(delegate: self)
    }

    func setupMapStyle(isOn: Bool) {
        guard let path = Bundle.main.path(forResource: isOn
            ? "NightStyle"
            : "RetroStyle",
                                          ofType: "json") else {
                                            return
        }

        let fileUrl = URL(fileURLWithPath: path)

        do {
            let data = try Data(contentsOf: fileUrl)
            guard let jsonString = data.prettyPrintedJSONString else {
                return
            }

            // Set the map style by passing a valid JSON string.
            mapView.mapStyle = try GMSMapStyle(jsonString: jsonString)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }

//    fileprivate func setRouteInMap() {
//
//        guard let markersArray = markers?.markers else {
//            return
//        }
//
//        let marker = markersArray[0]
//        let marker2 = markersArray[1]
//
//        guard let latitude = marker.coordinates.first,
//            let longitude = marker.coordinates.last else {
//                return
//        }
//
//        guard let latitude2 = marker2.coordinates.first,
//            let longitude2 = marker2.coordinates.last else {
//                return
//        }
//
//        let position = CLLocationCoordinate2DMake(latitude, longitude)
//        let position2 = CLLocationCoordinate2DMake(latitude2, longitude2)
//
//        mapView.drawPolygon(from: position, to: position2)
//
//    }

    func setupCluster() {
        // Set up the cluster manager with the supplied icon generator and
        // renderer.
        let iconGenerator = ClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView,
                                           algorithm: algorithm,
                                           renderer: renderer)
        clusterManager.setDelegate(self, mapDelegate: self)
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

extension GMViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {

        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, _ in

            if let address = response?.firstResult(),
                let addressLines = address.lines {
                let item = POIItem(position: coordinate, name: addressLines.description)
                self.clusterManager.add(item)
                self.clusterManager.cluster()
            }
        }
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Tapped at coordinate: " + String(coordinate.latitude) + " "
            + String(coordinate.longitude))
    }

}

extension GMViewController: GMUClusterManagerDelegate {
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        print("tap cluster")

        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)

        return false
    }

    func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) -> Bool {
        print("tap cluster item")

        return false
    }
}

extension GMViewController: GMUClusterRendererDelegate {
    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
        switch object {
        case let markerPOIItem as POIItem:
            let marker = GMSMarker(position: markerPOIItem.position)
            marker.icon = GMSMarker.markerImage(with: MapsColors.mainColor)
            return marker
        default:
            return nil
        }
    }

}
