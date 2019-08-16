/*
 * Copyright (c) 2014 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import SceneKit

struct nodes {
    var title : String
    var node : SCNNode
}

class ARkitCarrousel: UIViewController {
    // UI
    @IBOutlet weak var geometryLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    
    var geometryNode: SCNNode = SCNNode()
    
    // Gestures
    var currentAngleX: Float = 0.0
    var currentAngleY: Float = 0.0
    var enableDoublePan : Bool = true
    var arrayNodes : [nodes] = []
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneSetup()
        arrayNodes = self.createNodes()
        
        geometryLabel.text = arrayNodes[0].title
        geometryNode = arrayNodes[0].node
        sceneView.scene!.rootNode.addChildNode(geometryNode)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    

//    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
//        geometryNode.removeFromParentNode()
//    // 2
//        switch sender.selectedSegmentIndex {
//        case 0:
//            geometryLabel.text = "Atoms\n"
//            geometryNode = Atoms.allAtoms()
//        case 1:
//            geometryLabel.text = "Methane\n(Natural Gas)"
//            geometryNode = Molecules.methaneMolecule()
//        case 2:
//            geometryLabel.text = "Ethanol\n(Alcohol)"
//            geometryNode = Molecules.ethanolMolecule()
//        case 3:
//            geometryLabel.text = "Polytetrafluoroethylene\n(Teflon)"
//            //geometryNode = Molecules.ptfeMolecule()
//            geometryNode = Molecules.coladaObject()
//            geometryNode.scale = SCNVector3(0.1, 0.1, 0.1)
//        default:
//            break
//        }
//        
//        // 3
//        sceneView.scene!.rootNode.addChildNode(geometryNode)
//    }
    
    func createNodes() -> [nodes]{
         var arrayNodes : [nodes] = []
        
        let colladaObject = Molecules.coladaObject()
        colladaObject.scale = SCNVector3(0.1, 0.1, 0.1)
        
        let node1 = nodes(title: "Atoms\n", node: Atoms.allAtoms())
        let node2 = nodes(title: "Methane\n(Natural Gas)", node: Molecules.methaneMolecule())
        let node3 = nodes(title: "figure\n", node: colladaObject)
     
        arrayNodes.append(node1)
        arrayNodes.append(node2)
        arrayNodes.append(node3)
        
        return arrayNodes
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
        cameraNode.position = SCNVector3Make(0, 0, 25)
        scene.rootNode.addChildNode(cameraNode)
        
        //        // 2
        //        let boxGeometry = SCNBox(width: 10.0, height: 10.0, length: 10.0, chamferRadius: 1.0)
        //        let boxNode = SCNNode(geometry: boxGeometry)
        //
        //        geometryNode = boxNode
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action:#selector(panGesture(_:)))
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.minimumNumberOfTouches = 1
        sceneView.addGestureRecognizer(panRecognizer)
        
        let panTwoFingers = UIPanGestureRecognizer(target: self, action:#selector(panGestureTwoFinguers(_:)))
        panTwoFingers.maximumNumberOfTouches = 2
        panTwoFingers.minimumNumberOfTouches = 2
        sceneView.addGestureRecognizer(panTwoFingers)
        
        
        // 3
        // sceneView.autoenablesDefaultLighting = true
        //sceneView.allowsCameraControl = true
        sceneView.scene = scene
    }
    
    @objc
    func panGesture(_ sender: UIPanGestureRecognizer) {
        
        if(sender.state == UIGestureRecognizer.State.began) {
            currentAngleY = geometryNode.eulerAngles.y
            currentAngleX = geometryNode.eulerAngles.x
        }
        
        let translation = sender.translation(in: sender.view!)
        
        var newAngleX = (Float)(translation.y)*(Float)(Double.pi)/180.0
        newAngleX += self.currentAngleX
        
        var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
        newAngleY += self.currentAngleY
        
        //geometryNode.transform = SCNMatrix4MakeRotation(newAngle, 0, 1, 0)
        geometryNode.eulerAngles.y = newAngleY
        geometryNode.eulerAngles.x = newAngleX
        
        if(sender.state == UIGestureRecognizer.State.ended) {
            currentAngleY = geometryNode.eulerAngles.y
            currentAngleX = geometryNode.eulerAngles.x
        }
    }
    
    @objc
    func panGestureTwoFinguers(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: sender.view!)
        
        if enableDoublePan {
            if abs(translation.x) > 90 {
                enableDoublePan = false
                geometryNode.removeFromParentNode()
                
                var index = searchIndexOnArrayNode(nodeToSearch: geometryNode, arrayOfNodes: arrayNodes.map{$0.node})

                if translation.x > 0 {
                    
                    if index == arrayNodes.count - 1{
                        index = 0
                    } else {
                        index += 1
                    }
                    
                    
                } else {

                }
                
                geometryLabel.text = arrayNodes[index].title
                geometryNode = arrayNodes[index].node
                sceneView.scene!.rootNode.addChildNode(geometryNode)
                
            }
            if(sender.state == UIGestureRecognizer.State.ended) {
                enableDoublePan = true
            }
        }
    }
    
    func searchIndexOnArrayNode(nodeToSearch: SCNNode, arrayOfNodes: [SCNNode]) -> Int {

        return arrayOfNodes.firstIndex(of: nodeToSearch) ?? 0
    }

}
