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

    @IBOutlet var collectionView: UICollectionView!
    var arrayNodes : [Nodes] = []
    let edge    : CGFloat = 10.0
    let spacing : CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayNodes = self.createNodes()

        let nib = UINib(nibName: "ARCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ARCell")
//        collectionView.register(ARCollectionCell.self,forCellWithReuseIdentifier: "ARCell")
        
        let nibCell = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "MyCollectionViewCell")
        
    }
    
    func createNodes() -> [Nodes] {
        var arrayNodes : [Nodes] = []
        
        let colladaObject = Molecules.coladaObject()
        colladaObject.scale = SCNVector3(0.1, 0.1, 0.1)
        
        let node1 = Nodes(title: "Atoms\n", node: Atoms.allAtoms())
        let node2 = Nodes(title: "Methane\n(Natural Gas)", node: Molecules.methaneMolecule())
        let node3 = Nodes(title: "figure\n", node: colladaObject)
        
        arrayNodes.append(node1)
        arrayNodes.append(node2)
        arrayNodes.append(node3)
        
        return arrayNodes
    }
    
    
    func configureCellView(cell : UICollectionViewCell, selected: Bool){
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 2
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        let borderColor: UIColor = selected ? .green : .red
        cell.layer.borderColor = borderColor.cgColor
        
    }
    
}

extension ARCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: edge, bottom: 0, right: edge)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfColumn = 2
        let collectionviewWidth = collectionView.frame.width
        let bothEdge =  CGFloat(edge + edge) // left + right
        let excludingEdge = collectionviewWidth - bothEdge
        let cellWidthExcludingSpaces = excludingEdge - (CGFloat(noOfColumn-1) * spacing)
        let finalCellWidth = cellWidthExcludingSpaces / CGFloat(noOfColumn)
        let height = finalCellWidth
        return CGSize(width: finalCellWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        
        cell.lbName.text = arrayNodes[indexPath.row].title
        cell.init3DObject(node: arrayNodes[indexPath.row].node)
        self.configureCellView(cell: cell, selected: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell {
            self.configureCellView(cell: cell, selected: true)}
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell else {
            return
        }
         self.configureCellView(cell: cell, selected: false)
        
    }
}
