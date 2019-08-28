//
//  SelectProjectViewController.swift
//  mapsApp
//
//  Created by Adrià González Fernández on 18/07/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    // MARK: - IBOutlets

    // MARK: - Fields

    let launchScreenView = LaunchScreenView()

    let mapsImage: UIImage? = UIImage.init(named: "mapsImage")?.withRenderingMode(.alwaysOriginal)
    let mapsImageSelected: UIImage? = UIImage.init(named: "mapsImageSelected")?.withRenderingMode(.alwaysOriginal)

    let gmImage: UIImage? = UIImage.init(named: "gmImage")?.withRenderingMode(.alwaysOriginal)
    let gmImageSelected: UIImage? = UIImage.init(named: "gmImageSelected")?.withRenderingMode(.alwaysOriginal)

    let arStreetImage: UIImage? = UIImage.init(named: "arStreetImage")?.withRenderingMode(.alwaysOriginal)
    let arStreetImageSelected: UIImage? = UIImage.init(named: "arStreetImageSelected")?.withRenderingMode(.alwaysOriginal)

    let tensorFlowImage: UIImage? = UIImage.init(named: "tensorFlowImage")?.withRenderingMode(.alwaysOriginal)
    let tensorFlowImageSelected: UIImage? = UIImage.init(named: "tensorFlowImageSelected")?.withRenderingMode(.alwaysOriginal)

    // MARK: - Constructor

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(launchScreenView)
        view.bringSubviewToFront(launchScreenView)
        launchScreenView.frame = view.bounds

        setupUI()
    }

    // MARK: - Life cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        launchScreenView.startAnimation()
    }

    // MARK: - IBAction

    // MARK: - Helpers

    func setupUI() {

        //self.setStatusBarStyle(.lightContent)

        setupTabBarController()

    }

    func setupTabBarController() {

        guard let mapsViewController = setupMaps(),
            let googleMapsViewController = setupGoogleMaps(),
            let arStreetViewController = setupARStreet(),
            let tensorFlowViewController = setupTensorFlow()
            else { return }

        mapsViewController.tabBarItem = UITabBarItem(title: "Maps",
                                                     image: mapsImage,
                                                     selectedImage: mapsImageSelected)
        mapsViewController.title = "Maps"

        googleMapsViewController.tabBarItem = UITabBarItem(title: "Google Maps",
                                                     image: gmImage,
                                                     selectedImage: gmImageSelected)
        googleMapsViewController.title = "Google Maps"

        arStreetViewController.tabBarItem = UITabBarItem(title: "AR Street",
                                                         image: arStreetImage,
                                                         selectedImage: arStreetImageSelected)
        arStreetViewController.title = "AR Street"

        tensorFlowViewController.tabBarItem = UITabBarItem(title: "Tensor Flow",
                                                           image: tensorFlowImage,
                                                           selectedImage: tensorFlowImageSelected)

        tensorFlowViewController.title = "Tensor Flow"

        let viewControllerList = [ googleMapsViewController,
                                   mapsViewController,
                                   arStreetViewController,
                                   tensorFlowViewController ]

        viewControllers = viewControllerList.map {
            UINavigationController(rootViewController: $0)
        }

    }

    func setupMaps() -> UIViewController? {
        let storyboard = UIStoryboard.init(name: "map",
                                           bundle: nil)

        AnalyticsManager.sendEvent(id: "MapViewController", name: "map", content: "content")
        return storyboard.instantiateInitialViewController() as? MapViewController
    }

    func setupGoogleMaps() -> UIViewController? {
        let storyboard = UIStoryboard.init(name: "GoogleMaps",
                                           bundle: nil)
        
        AnalyticsManager.sendEvent(id: "GMViewController", name: "GoogleMaps", content: "content")
        return storyboard.instantiateInitialViewController() as? GMViewController
    }

    func setupARStreet() -> UIViewController? {
        AnalyticsManager.sendEvent(id: "ARCollectionViewController", name: "AR", content: "content")
         return ARCollectionViewController()
    }

    func setupTensorFlow() -> UIViewController? {
        let storyboard = UIStoryboard.init(name: "TensorFlow",
                                           bundle: nil)

        AnalyticsManager.sendEvent(id: "TFMainViewController", name: "TensorFlow", content: "content")
        return storyboard.instantiateInitialViewController() as? TFMainViewController
    }
}
