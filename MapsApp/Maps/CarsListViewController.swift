//
//  CarsListViewController.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 01/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit

class CarsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var teams: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "CarListCellTableViewCell", bundle: nil), forCellReuseIdentifier: "CarListCell")

        teams = ["Atletico de Madrid", "Barcelona", "Deportivo de la Coruña", "Las Palmas", "Malaga", "Rayo Vallecano", "Sporting", "Real Sociedad", "Espanyol", "Mallorca", "Valladolid", "Eibar",  "Ponferradina", "Albacete"]
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CarListCell", for: indexPath) as? CarListCellTableViewCell
            else { return UITableViewCell() }
        cell.carImage?.image = UIImage.init(named: "seat-ibiza")
        cell.carLabel?.text = teams[indexPath.row]
        
        return cell
    }
    
    
}
