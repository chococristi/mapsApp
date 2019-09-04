//
//  CarsListViewController.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 01/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit
import ARKit

class CarsListViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var parkingName: UILabel?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var carSceneView: CarSceneView!
    
    
    weak var delegate: CarListDelegate?
    var arrayNodes: [Nodes] = []

    // MARK: - Fields

    var marker: Marker! {
        didSet {
            guard oldValue != self.marker else { return }

            guard let tableView = tableView else {
               return
            }

            setupLabel()

            tableView.reloadData()

            setupNodes()
        }
    }

    // MARK: - Contructor

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Helpers

    func setup() {

        edgesForExtendedLayout = []

        setupLabel()

        setupTableView()
    }

    func setupLabel() {
        guard let label = parkingName, marker != nil else { return }
        label.text = marker.name
    }

    func setupTableView() {

        guard let tableView = tableView else {
                return
        }

        tableView.register(CarListCellTableViewCell.nib,
                           forCellReuseIdentifier: CarListCellTableViewCell.identifier)

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

            case "Leon":
                collada = Molecules.coladaObject(name: "cherub", path: "art.scnassets/cherub/cherub.dae")
                node = Nodes(title: "cherub\n", node: collada)
            default:
                collada = Molecules.coladaObject(name: "car", path: "art.scnassets/carScene/source/car.dae")
                node = Nodes(title: "car\n", node: collada)
            }

            arrayNodes.append(node)
        }

    }
}

extension CarsListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marker.cars.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CarListCellTableViewCell.identifier,
                                                       for: indexPath) as? CarListCellTableViewCell
            else { return UITableViewCell() }

        cell.item = marker.cars[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.expandViewOnClick()
        let node = arrayNodes[indexPath.row].node
        let car = marker.cars[indexPath.row]
        carSceneView.init3DObject(node: node, car: car)
    }
}

protocol CarListDelegate: class {
    func expandViewOnClick()
}
