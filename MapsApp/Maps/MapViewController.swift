//
//  ViewController.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 08/07/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
// https://www.raywenderlich.com/823-advanced-mapkit-tutorial-custom-tiles

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000 //put 900 to zoom in directly
    var previousLocation: CLLocation?

    let geoCoder = CLGeocoder()
    var markers: Markers?
    var annotationsArray: [MKAnnotation] = []

    // MARK: LifeCycle functions

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []

        checkLocationServices()
    }

    // MARK: Setup functions

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func setupMap() {
        guard let path = Bundle.main.path(forResource: "bcnlocations", ofType: "json") else { return }
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

    // MARK: Check functions
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
            setupMap()
        } else {
            //self.present(Alert.alert(message: "You should enable Location services!"), animated: true)
        }
    }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }

    // MARK: Location functions

    func startTrackingUserLocation() {
        //it shows the blue point in the map
        mapView.showsUserLocation = true

        //it centers the view on the blue point in the map
        centerViewOnUserLocation()

        //it starts the didUpdateLocations function in delegate
        locationManager.startUpdatingLocation()
    }

    func centerViewOnUserLocation() {
        #if targetEnvironment(simulator)
        // TODO harcoded to work with Simulator (if not harcoded, we are in California)
        let location = CLLocationCoordinate2DMake(41.397272, 2.159148)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        #else
        //TODO CORRECT CODE to use with a DEVICE!!!
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
        #endif
    }

    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    // MARK: Map functions

    fileprivate func setAnnotationsInMap() {

        guard let markersArray = markers?.markers else { return }
        for marker in markersArray {
            //TODO first / last i'm not sure if can be done better
            guard let latitude = marker.coordinates.first, let longitude = marker.coordinates.last else { return }
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = marker.name
            mapView.addAnnotation(annotation)
        }
    }

    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
    }
}

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate {

    //this function allows to SHOW THE NUMBER OF CLUSTER annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
        annotationView.clusteringIdentifier = "identifier"
        return annotationView
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionDidChangeAnimated")
        //let allAnnotations : [MKAnnotation] = mapView.annotations
        //print("number of total annotations : \(allAnnotations.count)")
        //print(allAnnotations.first?.title) //this is random orderer

        //let selectedAnnotations : [MKAnnotation] = mapView.selectedAnnotations
        //print("number of selected annotations : \(selectedAnnotations.count)")
        //print(selectedAnnotations.first?.title)

    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //this center the region on the annotation that the user has tapped
        print("didSelect annotation")
        guard let location = view.annotation?.coordinate else { return }
        let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)

        // navigateToDetail()
    }

    func navigateToDetail() {

        let next: MapDetailViewController = MapDetailViewController()
        self.present(next, animated: true, completion: nil)
//        
//        let mapStoryboard = UIStoryboard(name: "map", bundle: Bundle.main)
//        if let mapDetailViewController = mapStoryboard.instantiateViewController(withIdentifier: "MapDetailViewController") as? UIViewController {
//            self.present(mapDetailViewController, animated: true, completion: nil)
//        }
    }

    // func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    // let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
    // renderer.strokeColor = .blue
    // renderer.lineWidth = 1
    // return renderer
    // }

}
