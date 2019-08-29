//
//  ARCollectionViewController.swift
//  mapsApp
//
//  Created by Adrià González Fernández on 22/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit
import ARKit

class ARCollectionViewController: UIViewController {

    @IBOutlet var buttonToAR: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    var arrayNodes : [Nodes] = []
    let edge    : CGFloat = 10.0
    let spacing : CGFloat = 10.0
    var selectedItem : Int = -1
    let flowLayout = ZoomAndSnapFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        arrayNodes = self.createNodes()

        buttonToAR.isEnabled = false

        setup()
    }

    func setup() {
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.collectionViewLayout = flowLayout
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(MyCollectionViewCell.nib,
                                forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
    }

    func createNodes() -> [Nodes] {
        var arrayNodes : [Nodes] = []

        let colladaObject1 = Molecules.coladaObject(name: "cherub", path: "art.scnassets/cherub/cherub.dae")
        colladaObject1.scale = SCNVector3(0.1, 0.1, 0.1)

        let colladaObject2 = Molecules.coladaObject(name: "car", path: "art.scnassets/carScene/source/car.dae")
        colladaObject2.scale = SCNVector3(0.02, 0.02, 0.02)

        let node1 = Nodes(title: "Atoms\n", node: Atoms.allAtoms())
        let node2 = Nodes(title: "Methane\n(Natural Gas)", node: Molecules.methaneMolecule())
        let node3 = Nodes(title: "figure\n", node: colladaObject1)
        let node4 = Nodes(title: "figure\n", node: colladaObject2)

        arrayNodes.append(node1)
        arrayNodes.append(node2)
        arrayNodes.append(node3)
        arrayNodes.append(node4)

        return arrayNodes
    }

    func configureCellView(cell : UICollectionViewCell, selected: Bool) {

        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 2
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        let borderColor: UIColor = selected ? .green : .red
        cell.layer.borderColor = borderColor.cgColor

    }
    @IBAction func goToAR(_ sender: Any) {

        let viewController = PlaceObjectsplaneViewController()
        arrayNodes[selectedItem].node.removeAction(forKey: "turn")
        viewController.nodeModel = arrayNodes[selectedItem].node
        self.navigationController?.pushViewController(viewController, animated: false)

    }
}

extension ARCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNodes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyCollectionViewCell.identifier,
            for: indexPath) as? MyCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.lbName.text = arrayNodes[indexPath.row].title
        cell.init3DObject(node: arrayNodes[indexPath.row].node)
        self.configureCellView(cell: cell, selected: indexPath.row == self.selectedItem)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell else {
            return
        }

        cell.play()
        selectedItem = indexPath.row
        buttonToAR.isEnabled = true
        self.configureCellView(cell: cell, selected: true)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell else {
            return
        }

        cell.stop(node: arrayNodes[indexPath.row].node)
        self.configureCellView(cell: cell, selected: false)
    }
}
