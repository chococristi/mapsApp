//
//  MyCollectionViewCell.swift
//  uicollectionviewcell-from-xib
//
//  Created by bett on 8/18/17.
//  Copyright © 2017 bett. All rights reserved.
//

import UIKit
import ARKit

class MyCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets

    @IBOutlet var sceneView: SCNView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet var view: UIView!

    // MARK: - Fields

    static var action: String = "turn"

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle(for: MyCollectionViewCell.self))
    }

    static var identifier: String {
        return String(describing: self)
    }

    var node = SCNNode()

    var item: Nodes? {
        didSet {
            guard let item = item else {
                return
            }

            lbName.text = item.title
            init3DObject(node: item.node)
        }
    }

    override var isSelected: Bool {
        didSet {
            guard oldValue != self.isSelected else { return }

            refreshBorderColor(color: isSelected ? .green : .red)

            doAction(isSelected: isSelected)
        }
    }

    // MARK: - Constructor

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }

    // MARK: - Life cycle

    override func prepareForReuse() {
        super.prepareForReuse()
        //hide or reset anything you want

        node.removeFromParentNode()
    }

    // MARK: - Helpers

    func setup() {
        setupUI()

        setupScene()
    }

    func setupUI() {

        layer.masksToBounds = true
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.shadowOffset = CGSize(width: -1, height: 1)

        refreshBorderColor(color: isSelected ? .green : .red)
    }

    func setupScene() {
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
        cameraNode.position = SCNVector3Make(0, 0, 20)
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

        self.sceneView.scene = scene
    }

    func refreshBorderColor(color: UIColor) {
        layer.borderColor = color.cgColor
    }

    func init3DObject(node: SCNNode) {
        self.node = node
        self.sceneView.scene?.rootNode.addChildNode(node)
    }

    func doAction(isSelected: Bool) {
        if isSelected {
            play()
        } else {
            stop()
        }
    }

    func play() {

        let action = SCNAction.repeatForever(SCNAction.rotate(by: .pi,
                                                              around: SCNVector3(0, 1, 0),
                                                              duration: 5))
        node.runAction(action,
                       forKey: MyCollectionViewCell.action)

    }

    func stop() {

       node.removeAction(forKey: MyCollectionViewCell.action)
    }

}
