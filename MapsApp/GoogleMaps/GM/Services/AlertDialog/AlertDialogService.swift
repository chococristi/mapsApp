//
//  AlertDialogService.swift
//  mapsApp
//
//  Created by Carles Cañades Torrents on 22/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import Foundation
import UIKit

public class AlertDialogService {

    // MARK: - Fields

    public static var sharedInstance: AlertDialogService = AlertDialogService()
    
    // MARK: - Methods

    public func showAlert(title: String?,
                          message: String?,
                          btAcceptText: String?) {
        
        DispatchQueue.main.async {

            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: btAcceptText,
                                                    style: .default))
            
            alertController.show()
        }
    }
    
    public func showAlert(title: String?,
                          message: String?,
                          btAcceptText: String?,
                          btAcceptCompletion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)

            let action = UIAlertAction(title: btAcceptText,
                                       style: .default) { _ in
                                        btAcceptCompletion()
            }

            alertController.addAction(action)
            
            alertController.show()

        }
    }

    public func showAlert(title: String?,
                          message: String?,
                          btAcceptText: String?,
                          btCancelText: String?,
                          btAcceptCompletion: @escaping () -> Void) {
        
        DispatchQueue.main.async {

            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: btCancelText,
                                             style: .cancel,
                                             handler: nil)
            
            alertController.addAction(cancelAction)
            
            let action = UIAlertAction(title: btAcceptText,
                                       style: .default) { _ in
                                        btAcceptCompletion()
            }

            alertController.addAction(action)
            
            alertController.show()

        }
    }

    public func showAlert(title: String?,
                          message: String?,
                          btAcceptText: String?,
                          btAcceptCompletion: @escaping () -> Void,
                          btCancelCompletion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "cancel",
                                             style: .cancel) { _ in
                                                btCancelCompletion()
            }
            alertController.addAction(cancelAction)

            let action = UIAlertAction(title: btAcceptText,
                                       style: .default) { _ in
                                        btAcceptCompletion()
            }
            alertController.addAction(action)

            alertController.show()
        }
    }

    // MARK: - Contructor

    private init() {
        
    }
}

public extension UIAlertController {
    func show() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        window.rootViewController = viewController
        window.windowLevel = UIWindow.Level.alert + 1
        window.makeKeyAndVisible()
        viewController.present(self, animated: true, completion: nil)
    }
}
