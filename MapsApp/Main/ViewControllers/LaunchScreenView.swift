//
//  LaunchScreenView.swift
//  mapsApp
//
//  Created by Carles Cañades Torrents on 14/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import Lottie
import UIKit

public class LaunchScreenView: UIView {

    // MARK: - IBOutlets

    // MARK: - Fields

    var animationView: AnimationView = AnimationView()
    let lodingJson: String = "SplashScreenWhiteColor"
    // MARK: - Properties

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

        backgroundColor = MapsColors.mainColor

        setupAnimationView()

    }

    func setupAnimationView() {
        let animation = Animation.named(lodingJson)

        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce

        self.addSubview(animationView)

        animationView.translatesAutoresizingMaskIntoConstraints = false

        self.addConstraint(NSLayoutConstraint(item: animationView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerX,
                                              multiplier: 1.0,
                                              constant: 1))

        self.addConstraint(NSLayoutConstraint(item: animationView,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerY,
                                              multiplier: 1.0,
                                              constant: 1))

        animationView.addConstraint(NSLayoutConstraint(item: animationView,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .notAnAttribute,
                                                       multiplier: 1.0,
                                                       constant: 201))

        animationView.addConstraint(NSLayoutConstraint(item: animationView,
                                                       attribute: .width,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .notAnAttribute,
                                                       multiplier: 1.0,
                                                       constant: 250))
    }

    public func startAnimation() {
        animationView.play { _ in
            self.removeFromSuperview()
        }

    }
    public func stopAnimation() {
        animationView.stop()
    }
}
