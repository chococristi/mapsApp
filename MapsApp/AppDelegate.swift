//
//  AppDelegate.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 08/07/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

let googleApiKey = "AIzaSyAdE8r0bQcPQfye1dC_LKX16OWIuqPvYmU"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        setup()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary
        // interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins
        // the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
        // Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application
        // state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the
        // changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive.
        // If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Helpers

    func setup() {

        setupFirebase()

        setupGoogleMaps()

        setupNavigationBar()

        setupTabBar()

        setupTabBarItem()

        setupRootViewController()
    }

    func setupFirebase() {
        FirebaseApp.configure()
    }
    func setupGoogleMaps() {
        GMSServices.provideAPIKey(googleApiKey)
    }

    func setupNavigationBar() {

        let navigationBarAppearance = UINavigationBar.appearance()

        navigationBarAppearance.tintColor = .white
        navigationBarAppearance.barTintColor = MapsColors.mainColor

        if #available(iOS 11.0, *) {
            //To change iOS 11 navigationBar largeTitle color

            navigationBarAppearance.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white]
        }

        // for default navigation bar title color
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white]

    }

    func setupTabBar() {

        let tabBarAppearace = UITabBar.appearance()

        tabBarAppearace.isTranslucent = false
        tabBarAppearace.barTintColor = .white
    }

    func setupTabBarItem() {

        let tabBarItemAppearace = UITabBarItem.appearance()

        tabBarItemAppearace.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: MapsColors.secondaryColor],
                                               for: .normal)
        tabBarItemAppearace.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: MapsColors.mainColor],
                                               for: .selected)
    }

    func setupRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)

        let containerViewController = ContainerViewController()

        window.flatMap({ window in
            window.rootViewController = containerViewController
            window.makeKeyAndVisible()
        })
    }

}
