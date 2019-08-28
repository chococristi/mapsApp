//
//  ClusterIconGenerator.swift
//  mapsApp
//
//  Created by Carles Cañades Torrents on 28/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import Foundation

class ClusterIconGenerator: NSObject, GMUClusterIconGenerator {

    private struct IconSize {

        private let initialFontSize: CGFloat = 12
        private let fontMultiplier: CGFloat = 0.1

        private let initialSize: CGFloat = 25
        private let sizeMultiplier: CGFloat = 0.18

        /**
         Rounded cluster sizes  (like 10+, 20+, etc.)
         */
        private let sizes = [10,20,50,100,200,500,1000]

        let size: UInt

        /**
         Returns scale level based on size index in `sizes`. Returns `1` if size doesn't have rounded representation
         */
        private var scaleLevel: UInt {
            if let index = sizes.lastIndex(where: { $0 <= size }) {
                return UInt(index) + 2
            } else {
                return 1
            }
        }

        /**
         Returns designed title from cluster's size
         */
        var designedTitle: String {
            if let size = sizes.last(where: { $0 <= size }) {
                return "\(size)+"
            } else {
                return "\(size)"
            }
        }

        /**
         Returns initial font size multiplied by recursively created multiplier
         */
        var designedFontSize: CGFloat {
            let multiplier: CGFloat = (1...scaleLevel).reduce(1) { initialfontSize,_ in initialfontSize + initialfontSize * fontMultiplier }
            return initialFontSize * multiplier
        }

        /**
         Returns initial `CGSize` multiplied by recursively created multiplier
         */
        var designedSize: CGSize {
            let multiplier: CGFloat = (1...scaleLevel).reduce(1) { initialfontSize,_ in initialfontSize + initialfontSize * sizeMultiplier }
            return CGSize(width: initialSize * multiplier, height: initialSize * multiplier)
        }

    }

    /**
     Returns image based on current cluster's size
     */
    func icon(forSize size: UInt) -> UIImage! {

        let iconSize = IconSize(size: size)

        let frame = CGRect(origin: .zero, size: iconSize.designedSize)

        let view = UIView(frame: frame)
        view.layer.cornerRadius = iconSize.designedSize.height / 2
        view.backgroundColor = MapsColors.mainColor

        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.textColor = .white
        label.text = iconSize.designedTitle
        view.addSubview(label)

        return view.asImage
    }

}

extension UIView {

    var asImage: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }

}
