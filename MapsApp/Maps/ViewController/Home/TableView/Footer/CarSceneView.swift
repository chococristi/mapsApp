//
//  CarSceneView.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 29/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit
import ARKit

class CarSceneView: UIView {

    @IBOutlet weak var sceneView: SCNView!
    var node = SCNNode()

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle(for: CarSceneView.self))
    }

    static var identifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupScene()
    }

    func setupScene() {
        let newScene = SCNScene()
        guard self.sceneView != nil else { return }
        self.sceneView.scene = newScene
    }

    func init3DObject(node: SCNNode) {
        self.node = node
        guard self.sceneView != nil else { return }
        self.sceneView.scene?.rootNode.addChildNode(node)
    }

}
