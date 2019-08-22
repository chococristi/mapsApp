//
//  InfoCell.swift
//  mapsApp
//
//  Created by Carles Cañades Torrents on 13/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    // MARK: - Fields

    static var nib: UINib {
        return UINib(nibName: identifier,
                     bundle: Bundle(for: InfoCell.self))
    }

    static var identifier: String {
        return String(describing: self)
    }

    // MARK: - Constructor

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
