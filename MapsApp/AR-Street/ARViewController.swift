//
//  ARViewController.swift
//  mapsApp
//
//  Created by Adrià González Fernández on 23/07/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var ARScene: ARSCNView!
    let config = ARWorldTrackingConfiguration()
    let capsuleNode = SCNNode(geometry: SCNCapsule(capRadius: 0.03, height: 0.1))

    override func viewDidLoad() {
        super.viewDidLoad()
        ARScene.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        config.planeDetection = .vertical
        ARScene.session.run(config)
        
        ARScene.delegate = self
        
        
        //self.configureCapsule()

        // Do any additional setup after loading the view.
    }

    
    func configureCapsule() {
        capsuleNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        capsuleNode.eulerAngles = SCNVector3(0,0,Double.pi/2)
        capsuleNode.position = SCNVector3(0.1, 0.1, -0.1)
        ARScene.scene.rootNode.addChildNode(capsuleNode)
    }
    
    func createFloorNode(anchor:ARPlaneAnchor) ->SCNNode{
        
        let floorNode = SCNNode(geometry: SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))) //1
        
        floorNode.position=SCNVector3(anchor.center.x,0,anchor.center.z)
        
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        floorNode.geometry?.firstMaterial?.isDoubleSided = true
        
        floorNode.eulerAngles = SCNVector3(Double.pi/2,0,0)
        
        return floorNode
    }

    //Delegates:
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return} //1
        
        let planeNode = createFloorNode(anchor: planeAnchor) //2
        
        node.addChildNode(planeNode) //3
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        node.enumerateChildNodes{(node, _) in
        node.removeFromParentNode()
        }
        
        let planeNode = createFloorNode(anchor: planeAnchor)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
        guard let _ = anchor as? ARPlaneAnchor else {return}
        
        node.enumerateChildNodes{(node,_) in
            node.removeFromParentNode()
        }
    }
}
