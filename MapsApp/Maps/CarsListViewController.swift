//
//  CarsListViewController.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 01/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit

class CarsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var marker: Marker!

    @IBOutlet weak var parkingName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        parkingName.text = marker.name

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CarListCellTableViewCell.nib, forCellReuseIdentifier: CarListCellTableViewCell.identifier)
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

}
