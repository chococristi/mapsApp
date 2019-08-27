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
    @IBOutlet weak var bottomSheetView: CurvedView!
    @IBOutlet weak var bottomContainerView: UIView!

    @IBOutlet weak var topSheetConstraint: NSLayoutConstraint!
    @IBOutlet weak var littleView: UIView!

    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000 //put 900 to zoom in directly
    let geoCoder = CLGeocoder()

    let kTopFullScreen: CGFloat = .zero
    let kTopMidScreen: CGFloat = UIScreen.main.bounds.height * 1/2
    let kTopLowScreen: CGFloat = UIScreen.main.bounds.height

    var initialTopSpace: CGFloat = 300.0
    var previousLocation: CLLocation?
    var annotationsArray: [MKAnnotation] = []

    // MARK: LifeCycle functions

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        setAnnotationsInMap()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didPan(panGesture:)))
        bottomSheetView.addGestureRecognizer(panGesture)
        edgesForExtendedLayout = []
        //TODO cambiar pines
    }

    override func viewDidAppear(_ animated: Bool) {
        setupBottomView()
    }

    // MARK: Setup functions

    func setupBottomView() {
        //NOT WORKING
        bottomSheetView.layer.shadowPath = UIBezierPath(roundedRect: bottomSheetView.bounds, cornerRadius: 5).cgPath
        bottomSheetView.layer.shadowOffset = CGSize(width: 5, height: 5)
        bottomSheetView.layer.shadowColor = UIColor.black.cgColor
        bottomSheetView.layer.shadowRadius = 1
        bottomSheetView.layer.shadowOpacity = 1
        bottomSheetView.layer.masksToBounds = false

        topSheetConstraint.constant = UIScreen.main.bounds.height
        littleView.layer.cornerRadius = 3
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    //    func setupMap() {
    //        guard let path = Bundle.main.path(forResource: "bcnlocations", ofType: "json") else { return }
    //        let url = URL(fileURLWithPath: path)
    //        do {
    //            let data = try Data(contentsOf: url)
    //            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    //
    //            guard let array = json as? [String: Any] else { return }
    //            self.markers = Markers.init(json: array)
    //            setAnnotationsInMap()
    //        } catch {
    //            print(error)
    //        }
    //    }

    // MARK: Check functions
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
            //            setupMap()
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
        @unknown default:
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

        let markersArray = markers

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

        if annotation is MKUserLocation { return nil }

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
        centerRegionOnPin(mapView: mapView, pin: view)

        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.4,
                       delay: 0.2,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseInOut,
                       animations: {
            self.topSheetConstraint?.constant = self.kTopMidScreen
            self.view.layoutIfNeeded()
        }, completion: nil)

        if let clustered = view.annotation as? MKClusterAnnotation {
            var minLat = CLLocationDegrees(exactly: 90)!
            var maxLat = CLLocationDegrees(exactly: -90)!
            var minLong = CLLocationDegrees(exactly: 180)!
            var maxLong = CLLocationDegrees(exactly: -180)!
            clustered.memberAnnotations.forEach { (annotation) in
                let coordinate = annotation.coordinate
                minLat = min(minLat, coordinate.latitude)
                maxLat = max(maxLat, coordinate.latitude)
                minLong = min(minLong, coordinate.longitude)
                maxLong = max(maxLong, coordinate.longitude)
            }

            let centerLat = (minLat + maxLat) / 2
            let centerLong = (minLong + maxLong) / 2
            let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLong)
            let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLong - minLong) * 1.5) // with some padding
            let region = MKCoordinateRegion(center: center, span: span)

            mapView.setRegion(region, animated: true)
        }

        guard let marker = getMarkerFromAnnotation(view: view) else {
            //TODO hacer zoom
            //TODO bajar el cuadrado si está seleccionado
//            let pin = view as! MKPinAnnotationView
//            zoomInOnPin(annotation: pin.annotation!)
            return
            //TODO tambien hacer q se deseleccione al hacer tap fuera
        }

        navigateToDetail(marker: marker)

    }

    func zoomInOnPin(annotation:MKAnnotation) {
        let zoomOutRegion = MKCoordinateRegion(center: mapView.region.center, span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09))
        mapView.setRegion(zoomOutRegion, animated: true)
    }

    func getMarkerFromAnnotation(view: MKAnnotationView) -> Marker? {
        var annotation = MKPointAnnotation()
        if let anAnnotation = view.annotation as? MKPointAnnotation {
            annotation = anAnnotation
        }
        let selectedTitle = "\(annotation.title ?? "")"

        if let markerFound = markers.first(where: { $0.name == selectedTitle }) {
            return markerFound
        }
        return nil
    }

    func centerRegionOnPin(mapView: MKMapView, pin: MKAnnotationView) {
        guard let location = pin.annotation?.coordinate else { return }
        let actualSpanRegion = mapView.region.span
        let region = MKCoordinateRegion(center: location, span: actualSpanRegion)
        mapView.setRegion(region, animated: true)
    }

    func navigateToDetail(marker : Marker) {

        let controller = CarsListViewController()

        addChild(controller)
        controller.marker = marker
        controller.view.frame = bottomContainerView.bounds
        bottomContainerView.addSubview(controller.view)
        controller.didMove(toParent: self)

    }

}

extension MapViewController {

    @objc func didPan(panGesture: UIPanGestureRecognizer) {

        let translation = panGesture.translation(in: view)

        switch panGesture.state {
        case .began:
            initialTopSpace = topSheetConstraint.constant
            setTopSheetLayout(withTopSpace: initialTopSpace + translation.y)
        case .changed:
            setTopSheetLayout(withTopSpace: initialTopSpace + translation.y)
        case .cancelled:
            setTopSheetLayout(withTopSpace: initialTopSpace)
        case .ended:
            translateBottomSheetAtEndOfPan(withVerticalTranslation: translation.y, gesture: panGesture)
            initialTopSpace = kTopMidScreen
        default:
            break
        }
    }

    func setTopSheetLayout(withTopSpace bottomSpace: CGFloat) {
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.view.setNeedsLayout()
            self.topSheetConstraint.constant = bottomSpace
            self.view.layoutIfNeeded()
        })
    }

    private func translateBottomSheetAtEndOfPan(withVerticalTranslation verticalTranslation: CGFloat, gesture: UIPanGestureRecognizer) {

        let direction = gesture.verticalDirection(target: self.view)
        let currentTopSpace = initialTopSpace + verticalTranslation
        var nextTopSpace: CGFloat = 0
        print("+++++ initialTopSpace: \(initialTopSpace)")
        print("+++++ verticalTranslation: \(verticalTranslation)")
        print("+++++ currentTopSpace (initialTop-Translation): \(currentTopSpace)")

        if isInMiddleTop(currentTopSpace) {
            nextTopSpace = (direction == .upper) ? kTopFullScreen : kTopMidScreen
            //TODO quitar borde redondeados

        } else if isInMiddleDown(currentTopSpace) {
            nextTopSpace = (direction == .upper) ? kTopMidScreen : kTopLowScreen
            //TODO poner borde redondeados
        } else {
            nextTopSpace = kTopLowScreen

        }
        setTopSheetLayout(withTopSpace: nextTopSpace)

    }

    func isInMiddleTop(_ currentTopSpace: CGFloat) -> Bool {
        if (currentTopSpace >= kTopFullScreen)
            && (currentTopSpace <= kTopMidScreen) {
            return true
        }
        return false
    }

    func isInMiddleDown(_ currentTopSpace: CGFloat) -> Bool {
        if (currentTopSpace >= kTopMidScreen)
            && (currentTopSpace <= kTopLowScreen) {
            return true
        }
        return false
    }

}
