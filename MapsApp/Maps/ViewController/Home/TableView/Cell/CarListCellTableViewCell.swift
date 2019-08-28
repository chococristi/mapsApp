//
//  CarListCellTableViewCell.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 26/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit

class CarListCellTableViewCell: UITableViewCell {

    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carLabel: UILabel!

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle(for: CarListCellTableViewCell.self))
    }

    static var identifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    func setupCell() {
        selectionStyle = .none
    }
}
