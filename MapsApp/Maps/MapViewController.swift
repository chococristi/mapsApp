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
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var topSheetConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000 //put 900 to zoom in directly
    let geoCoder = CLGeocoder()
    let DEFAULT_TOP: CGFloat = 300.0
    let TOP_FULL_SCREEN: CGFloat = 0
    let TOP_MID_SCREEN: CGFloat = 300
    let TOP_LOW_SCREEN: CGFloat = 600
    
    var initialTopSpace: CGFloat = 300.0
    var previousLocation: CLLocation?
    var markers: Markers?
    var annotationsArray: [MKAnnotation] = []
    
    // MARK: LifeCycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didPan(panGesture:)))
        bottomSheetView.addGestureRecognizer(panGesture)

    }
    
    // MARK: Setup functions
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func setupMap() {
        guard let path = Bundle.main.path(forResource: "bcnlocations", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            guard let array = json as? [String: Any] else { return }
            self.markers = Markers.init(json: array)
            setAnnotationsInMap()
        } catch {
            print(error)
        }
    }
    
    // MARK: Check functions
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
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
        }
    }
    
    // MARK: Location functions
    
    func startTrackingUserLocation(){
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
        centerRegionOnPin(mapView: mapView, pin: view)
        navigateToDetail()
    }
    
    func centerRegionOnPin(mapView: MKMapView, pin: MKAnnotationView) {
        guard let location = pin.annotation?.coordinate else { return }
        let actualSpanRegion = mapView.region.span
        let region = MKCoordinateRegion(center: location, span: actualSpanRegion)
        mapView.setRegion(region, animated: true)
    }
    
    func navigateToDetail() {
        let modalViewController = MapDetailViewController()
        modalViewController.transitioningDelegate = self
        modalViewController.modalPresentationStyle = .custom
        self.present(modalViewController, animated: true, completion: nil)
    }

}

extension MapViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
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
            translateBottomSheetAtEndOfPan(withVerticalTranslation: translation.y)
            initialTopSpace = DEFAULT_TOP
        default:
            break
        }
    }
    
    func setTopSheetLayout(withTopSpace bottomSpace: CGFloat) {
        UIView.animate(withDuration: 2, animations: {
            self.view.setNeedsLayout()
            self.topSheetConstraint.constant = bottomSpace
            self.view.setNeedsLayout()
        })
    }
    
//    private func translateBottomSheetAtEndOfPan(withVerticalTranslation verticalTranslation: CGFloat) {
//
//        // Changes bottom sheet state to either fully open or closed at the end of pan.
//        var topSpace = initialTopSpace - verticalTranslation
//        print("++++++++++++ top space : \(topSpace)")
//        var height: CGFloat = 0.0
//        if initialTopSpace == 0.0 {
//            height = bottomSheetView.bounds.size.height
//        }
//        else {
//            height = 100
//            //height = inferenceViewController!.collapsedHeight
//        }
//        print("++++++++++++ height : \(height)")
//
//        let currentHeight = bottomSheetView.bounds.size.height + topSpace
//         print("++++++++++++ currentHeight (height+topSpace) : \(currentHeight)")
//
//        if currentHeight - height <= 300 {
//            topSpace = 100 - bottomSheetView.bounds.size.height
//        }
//        else if currentHeight - height >= 100 {
//            topSpace = 0.0
//        }
//        else {
//            topSpace = initialTopSpace
//        }
//        print("++++++++++++ top space : \(topSpace)")
//        setTopSheetLayout(withTopSpace: topSpace)
//    }

    private func translateBottomSheetAtEndOfPan(withVerticalTranslation verticalTranslation: CGFloat) {
        
        var currentTopSpace = initialTopSpace + verticalTranslation
        var nextTopSpace: CGFloat = 0
        print("+++++ initialTopSpace: \(initialTopSpace)")
        print("+++++ verticalTranslation: \(verticalTranslation)")
        print("+++++ currentTopSpace (initialTop-Translation): \(currentTopSpace)")
        
        if (currentTopSpace >= TOP_FULL_SCREEN) && (currentTopSpace <= TOP_MID_SCREEN) {
            nextTopSpace = TOP_FULL_SCREEN
        } else if (currentTopSpace >= TOP_MID_SCREEN) && (currentTopSpace <= TOP_LOW_SCREEN){
            nextTopSpace = TOP_MID_SCREEN
        } else {
            nextTopSpace = TOP_LOW_SCREEN
        }
        setTopSheetLayout(withTopSpace: nextTopSpace)

    }

}


