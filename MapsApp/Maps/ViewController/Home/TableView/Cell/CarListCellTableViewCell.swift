//
//  CarListCellTableViewCell.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 26/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit

class CarListCellTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carLabel: UILabel!

    // MARK: - Fields

    static var nib: UINib {
        return UINib(nibName: identifier,
                     bundle: Bundle(for: CarListCellTableViewCell.self))
    }

    static var identifier: String {
        return String(describing: self)
    }

    var item: Car? {
        didSet {
            guard let item = item else {
                return
            }

            carImage?.image = UIImage.init(named: item.image)
            carLabel?.text = item.brand + " " + item.model
        }
    }

    // MARK: - Constructors

    override func awakeFromNib() {
        super.awakeFromNib()

        setupCell()
    }

    // MARK: - Helpers

    func setupCell() {
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if(selected) {
            carLabel.font = UIFont.boldSystemFont(ofSize: carLabel.font.pointSize)
        } else {
            carLabel.font = UIFont.systemFont(ofSize: carLabel.font.pointSize)
        }
    }
}
