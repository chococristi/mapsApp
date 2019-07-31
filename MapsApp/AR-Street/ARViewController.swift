//
//  ARViewController.swift
//  mapsApp
//
//  Created by Adrià González Fernández on 23/07/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    

    @IBOutlet var sceneView: ARSCNView!
    
    var animations  = [String: CAAnimation]()
    var idle: Bool = true
    var animationNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
        animationNode = loadAnimations()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "Photos", bundle: Bundle.main) else {
            print("No images available")
            return
        }
        
        configuration.trackingImages = trackedImages
        configuration.maximumNumberOfTrackedImages = 1
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.9)
            
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            
            
            //            let shipScene = SCNScene(named: "art.scnassets/ship.scn")!
            //            let shipNode = shipScene.rootNode.childNodes.first!
            //            shipNode.position = SCNVector3Zero
            //            shipNode.position.z = 0.15
            
           
            // Set up some properties
            animationNode.position = SCNVector3Zero
            animationNode.position.z = 0.15
            animationNode.scale = SCNVector3(0.001, 0.001, 0.001)
            
            
            planeNode.addChildNode(animationNode)
            planeNode.addAnimation(animations["dancing"]!, forKey: "dancing")
//            sceneView.scene.rootNode.addChildNode(animationNode)
//            sceneView.scene.rootNode.addAnimation(animations["dancing"]!, forKey: "dancing")
            //planeNode.addChildNode(shipNode)
            
            node.addChildNode(planeNode)
            
        }
        
        return node
        
    }
    
    func loadAnimations () -> SCNNode{
        // Load the character in the idle animation
        guard let idleScene = SCNScene(named: "art.scnassets/SalsaDancing/SalsaDancingFixed.dae") else {
            return SCNNode()
        }
        
        // This node will be parent of all the animation models
        let node = SCNNode()
        
        // Add all the child nodes to the parent node
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        // Add the node to the scene
        //planeNode.addChildNode(node)
        
        // Load all the DAE animations
        loadAnimation(withKey: "dancing", sceneName: "art.scnassets/SalsaDancing/SalsaDancingFixed", animationIdentifier: "SalsaDancingFixed-1")
        
        return node
        
    }
    
    func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
            // The animation will only play once
            animationObject.repeatCount = 1
            // To create smooth transitions between animations
            animationObject.fadeInDuration = CGFloat(1)
            animationObject.fadeOutDuration = CGFloat(0.5)
            
            // Store the animation for later use
            animations[withKey] = animationObject
        }
    }
    
    
}
