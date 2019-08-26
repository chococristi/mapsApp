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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
