//
//  SelectProjectViewController.swift
//  mapsApp
//
//  Created by Adrià González Fernández on 18/07/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit

class SelectProjectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func goToMaps(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "map", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() as? MapViewController{
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func goToARStreet(_ sender: Any) {
        //let storyboard = UIStoryboard.init(name: "map", bundle: nil)
         let vc = QRViewController()
        self.present(vc, animated: false, completion: nil)
        
    }
}
