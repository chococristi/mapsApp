//
//  MainButton.swift
//  mapsApp
//
//  Created by Carles Cañades Torrents on 28/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit

public class MainButton: UIButton {

    // MARK: - Fields

    // MARK: - Properties

    override public var isHighlighted: Bool {
        didSet {
            guard oldValue != self.isHighlighted else { return }

            borderWidth = isHighlighted ? 2 : .zero
        }
    }

    // MARK: - IBInspectable properties

    @IBInspectable public var borderWidth: CGFloat = .zero {
        didSet {
            refreshBorderWidth(width: borderWidth)
        }
    }

    @IBInspectable public var cornerRadius: CGFloat = 2 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }

    // MARK: - Constructor

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Helpers

    func setupUI() {

        refreshCorners(value: cornerRadius)
        refreshBorderWidth(width: borderWidth)

        refreshBorderColor(color: UIColor.white.cgColor)

        self.setTitleColor(.white, for: .highlighted)
        self.setBackgroundColor(MapsColors.mainColor, for: .highlighted)

        self.setTitleColor(.white, for: .normal)
        self.setBackgroundColor(MapsColors.mainColor, for: .normal)

        self.setTitleColor(.lightGray, for: .disabled)
        self.setBackgroundColor(.white, for: .disabled)

    }

    func refreshBorderWidth(width: CGFloat) {
        layer.borderWidth = width
    }

    func refreshBorderColor(color: CGColor) {
        layer.borderColor = color
    }

    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
}