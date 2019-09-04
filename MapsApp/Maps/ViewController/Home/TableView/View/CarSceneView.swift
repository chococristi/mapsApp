//
//  CarSceneView.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 02/09/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit
import ARKit

class CarSceneView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!

    var node = SCNNode()

    // MARK: - View Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
            Bundle.main.loadNibNamed(String(describing: CarSceneView.self), owner: self, options: nil)
            contentView.fixInView(self)
            sceneSetup()
            self.sceneView.scene?.rootNode.addChildNode(self.node)
    }

       func sceneSetup() {
            let newScene = SCNScene()

           let ambientLightNode = SCNNode()
           ambientLightNode.light = SCNLight()
           ambientLightNode.light!.type = SCNLight.LightType.ambient
           ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
           newScene.rootNode.addChildNode(ambientLightNode)
            self.sceneView.scene = newScene
        }

    func init3DObject(node: SCNNode, car: Car) {

//        self.sceneView.scene?.rootNode.enumerateChildNodes({(node, stop) in
//            node.removeFromParentNode()
//        })

        self.sceneView.scene?.rootNode.addChildNode(self.node)
        carNameLabel.text = car.brand + " " + car.model
        self.node = node

    }
}
