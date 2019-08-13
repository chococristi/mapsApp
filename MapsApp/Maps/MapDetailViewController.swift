//
//  MapDetailViewController.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 01/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit

class HalfSizePresentationController : UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            guard let theView = containerView else {
                return CGRect.zero
            }
            
            return CGRect(x: 0, y: theView.bounds.height/2 + 20, width: theView.bounds.width, height: theView.bounds.height/2)
        }
    }
}

class MapDetailViewController: UIViewController {
    
    @IBAction func maximizeButtonTapped(_ sender: Any) {
        //maximizeToFullScreen()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
//        if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
//            delegate.interactiveDismiss = false
//        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
