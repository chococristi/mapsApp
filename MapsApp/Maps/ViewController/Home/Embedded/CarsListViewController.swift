//
//  CarsListViewController.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 01/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit
import ARKit

class CarsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var delegate: CarListDelegate?
    var arrayNodes: [Nodes] = []

    var marker: Marker! {
        didSet {
            guard oldValue != self.marker else { return }
            parkingName.text = marker.name
            tableView.reloadData()
            setupNodes()
        }
    }

    @IBOutlet weak var parkingName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sceneContainer: CarSceneView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
         tableView.register(CarListCellTableViewCell.nib, forCellReuseIdentifier: CarListCellTableViewCell.identifier)

        tableView.dataSource = self
        tableView.delegate = self

        tableView.bounces = false
        tableView.separatorStyle = .none

    }

    func setupNodes() {

        for car in marker.cars {
            var collada: SCNNode
            var node: Nodes

            switch (car.model) {
            case "Ibiza":
                collada = Molecules.coladaObject(name: "dragon", path: "art.scnassets/car/dragon.dae")
                node = Nodes(title: "dragon\n", node: collada)
            case "Leon":
                collada = Molecules.coladaObject(name: "cherub", path: "art.scnassets/cherub/cherub.dae")
                node = Nodes(title: "cherub\n", node: collada)
            default:
                collada = Molecules.coladaObject(name: "dragon", path: "art.scnassets/car/dragon.dae")
                node = Nodes(title: "dragon\n", node: collada)
            }

            arrayNodes.append(node)
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marker.cars.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CarListCellTableViewCell.identifier,
                                                       for: indexPath) as? CarListCellTableViewCell
            else { return UITableViewCell() }
        cell.carImage?.image = UIImage.init(named: marker.cars[indexPath.row].image)
        cell.carLabel?.text = marker.cars[indexPath.row].brand + " " + marker.cars[indexPath.row].model

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.expandViewOnClick()
        let car = marker.cars[indexPath.row]
        sceneContainer.init3DObject(node: arrayNodes[indexPath.row].node, car: car)
    }

}

protocol CarListDelegate: class {
    func expandViewOnClick()
}
