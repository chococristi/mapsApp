//
//  CarsListViewController.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 01/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit

class CarsListViewController: UIViewController {

    var marker: Marker! {
        didSet {
            guard oldValue != self.marker else { return }

            parkingName.text = marker.name
            tableView.reloadData()
        }
    }

    @IBOutlet weak var parkingName: UILabel!
    @IBOutlet weak var tableView: UITableView!

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

}
