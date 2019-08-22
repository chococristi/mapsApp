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
            let arStreetViewController = setupARStreet(),
            let tensorFlowViewController = setupTensorFlow()
            else { return }

        mapsViewController.tabBarItem = UITabBarItem(title: "Maps",
                                                     image: mapsImage,
                                                     selectedImage: mapsImageSelected)
        mapsViewController.title = "Maps"

        arStreetViewController.tabBarItem = UITabBarItem(title: "ARStreet",
                                                         image: arStreetImage,
                                                         selectedImage: arStreetImageSelected)
        arStreetViewController.title = "ARStreet"

        tensorFlowViewController.tabBarItem = UITabBarItem(title: "TensorFlow",
                                                           image: tensorFlowImage,
                                                           selectedImage: tensorFlowImageSelected)

        tensorFlowViewController.title = "TensorFlow"

        let viewControllerList = [ mapsViewController,
                                   arStreetViewController,
                                   tensorFlowViewController ]

        viewControllers = viewControllerList.map {
            UINavigationController(rootViewController: $0)
        }

    }

    func setupMaps() -> UIViewController? {
        let storyboard = UIStoryboard.init(name: "map",
                                           bundle: nil)

        return storyboard.instantiateInitialViewController() as? MapViewController
    }

    func setupARStreet() -> UIViewController? {

         return ARkitCarrousel()
    }

    func setupTensorFlow() -> UIViewController? {

        let storyboard = UIStoryboard.init(name: "TensorFlow",
                                           bundle: nil)

        return storyboard.instantiateInitialViewController() as? TFMainViewController
    }
}
