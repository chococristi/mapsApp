//
//  ARCollectionViewController.swift
//  mapsApp
//
//  Created by Adrià González Fernández on 22/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit
import ARKit

class ARCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!
    var arrayNodes : [Nodes] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayNodes = self.createNodes()
        collectionView.delegate = self
        collectionView.dataSource = self
//        let nib = UINib(nibName: "ARCollectionCell", bundle: nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: "ARCell")
        collectionView.register(ARCollectionCell.self,forCellWithReuseIdentifier: "ARCell")
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
    
 
    
    // MARK - UICollectionViewDelegate
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
   
     func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return arrayNodes.count
    }
    
    
     func collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ARCell", for: indexPath) as! ARCollectionCell
        cell.text = arrayNodes[indexPath.row].title
        return cell
    }



}
