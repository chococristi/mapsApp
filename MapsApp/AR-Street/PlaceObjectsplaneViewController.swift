//
//  ViewController.swift
//  ARSceneKit
//
//  Created by Esteban Herrera on 7/7/17.
//  Copyright © 2017 Esteban Herrera. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PlaceObjectsplaneViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var sceneView: ARSCNView!

    var nodeModel:SCNNode!
    var roteNode :SCNNode!
    let nodeName = "cherub"
    var exist = false
    var currentAngleY: Float = 0.0
    var currentAngleX: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.antialiasingMode = .multisampling4X

        // Create a new scene
        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene

        let modelScene = SCNScene(named:
            "art.scnassets/cherub/cherub.dae")!

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGesture.delegate = self
        sceneView.addGestureRecognizer(panGesture)
        
        guard let _ = nodeModel else {
            nodeModel =  modelScene.rootNode.childNode(withName: nodeName, recursively: true)
            return
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let location = touches.first!.location(in: sceneView)

        // Let's test if a 3D Object was touch
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true

        let hitResults: [SCNHitTestResult]  = sceneView.hitTest(location, options: hitTestOptions)

        if let hit = hitResults.first {
            if let node = getParent(hit.node) {
                node.removeFromParentNode()
                exist = !exist
                return
            }
        }

        if !exist {
            // No object was touch? Try feature points
            let hitResultsFeaturePoints: [ARHitTestResult]  = sceneView.hitTest(location, types: .featurePoint)

            if let hit = hitResultsFeaturePoints.first {

                // Get the rotation matrix of the camera
                let rotate = simd_float4x4(SCNMatrix4MakeRotation(sceneView.session.currentFrame!.camera.eulerAngles.y, 0, 1, 0))

                // Combine the matrices
                let finalTransform = simd_mul(hit.worldTransform, rotate)
                sceneView.session.add(anchor: ARAnchor(transform: finalTransform))
                //sceneView.session.add(anchor: ARAnchor(transform: hit.worldTransform))
                exist = !exist
            }
        }

    }

    func getParent(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == nodeName {
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }

    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            DispatchQueue.main.async {
                let modelClone = self.nodeModel.clone()
                modelClone.position = SCNVector3Zero

                // Add model as a child of the node
                node.addChildNode(modelClone)
                self.roteNode = modelClone
                self.roteNode.scale = SCNVector3( 0.01,0.01,0.01)
            }
        }
    }

    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user

    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }

    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        guard let _ = self.roteNode else { return }
        let translation = gesture.translation(in: gesture.view)
        var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
        var newAngleX = (Float)(translation.y)*(Float)(Double.pi)/180.0

        newAngleY += currentAngleY
        roteNode?.eulerAngles.y = newAngleY

        newAngleX += currentAngleX
        roteNode?.eulerAngles.x = newAngleX

        if gesture.state == .ended {
            currentAngleY = newAngleY
            currentAngleX = newAngleX
        }
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
