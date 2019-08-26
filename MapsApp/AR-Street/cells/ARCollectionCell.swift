//
//  ARCollectionCell.swift
//  mapsApp
//
//  Created by Adrià González Fernández on 22/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit
import ARKit

class ARCollectionCell: UICollectionViewCell {

 
    @IBOutlet weak var label: UILabel!
    var object : SCNNode = SCNNode()
    var text : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //self.init3DObject(node: object)
    }
    
    func sceneSetup() {
        // 1
        let scene = SCNScene()
        
        //ligth 1
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        //ligth 2
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 0.5)
        omniLightNode.position = SCNVector3Make(50, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
        
        //ligth 3
        let omniLightNodeContra = SCNNode()
        omniLightNodeContra.light = SCNLight()
        omniLightNodeContra.light!.type = SCNLight.LightType.omni
        omniLightNodeContra.light!.color = UIColor(white: 0.75, alpha: 0.5)
        omniLightNodeContra.position = SCNVector3Make(-50, -50, -50)
        scene.rootNode.addChildNode(omniLightNodeContra)
        
        // camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 50)
        scene.rootNode.addChildNode(cameraNode)
        
//
//        let panRecognizer = UIPanGestureRecognizer(target: self, action:#selector(panGesture(_:)))
//        panRecognizer.maximumNumberOfTouches = 1
//        panRecognizer.minimumNumberOfTouches = 1
//        sceneView.addGestureRecognizer(panRecognizer)
//
//        let panTwoFingers = UIPanGestureRecognizer(target: self, action:#selector(panGestureTwoFinguers(_:)))
//        panTwoFingers.maximumNumberOfTouches = 2
//        panTwoFingers.minimumNumberOfTouches = 2
//        sceneView.addGestureRecognizer(panTwoFingers)

     //   self.ViewScene.scene = scene
    }
    
//    func init3DObject(node: SCNNode){
//        ViewScene.scene.rootNode.addChildNode(node)
//    }
}
