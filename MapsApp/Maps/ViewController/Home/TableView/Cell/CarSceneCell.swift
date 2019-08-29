//
//  CarSceneCell.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 28/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit
import ARKit

class CarSceneCell: UITableViewCell {

    @IBOutlet weak var sceneView: SCNView!

    var node = SCNNode()

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle(for: CarSceneCell.self))
    }

    static var identifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupScene()
        setupCell()
    }

    func setupCell() {
        selectionStyle = .none
    }

    func setupScene() {
        let scene = SCNScene()

        self.sceneView.scene = scene
    }

    func init3DObject(node: SCNNode) {
        self.node = node
        self.sceneView.scene?.rootNode.addChildNode(node)
    }
}
