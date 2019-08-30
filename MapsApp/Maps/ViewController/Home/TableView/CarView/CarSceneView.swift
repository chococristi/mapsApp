//
//  CarSceneView.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 30/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit

class CarSceneView: UIView {

    @IBOutlet var contentView: UIView!

    // MARK: - View Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: CarSceneView.self), owner: self, options: nil)
        contentView.fixInView(self)
    }

}
