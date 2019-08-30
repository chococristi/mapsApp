//
//  ContainerViewController.swift
//  mapsApp
//
//  Created by Carles Cañades Torrents on 23/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import Foundation
import UIKit

class ContainerViewController: UIViewController {

    enum SlideOutState {
        case bothCollapsed
        case leftPanelExpanded
        case rightPanelExpanded
    }

    // MARK: - IBOutlets

    // MARK: - Fields

    var centerViewController: MainViewController!

    var leftViewController: LeftViewController?
    var rightViewController: RightViewController?

    let centerPanelExpandedOffset: CGFloat = 90

    // MARK: - Properties

    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }

    // MARK: - Constructor

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Helpers

    func setup() {
        setupCenterViewController()
    }

    func setupCenterViewController() {
        centerViewController = UIStoryboard.centerViewController()

        view.addSubview(centerViewController.view)
        addChild(centerViewController)
        centerViewController.didMove(toParent: self)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(handlePanGesture(_:)))

        centerViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
}

// MARK: CenterViewController delegate

extension ContainerViewController {
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)

        if notAlreadyExpanded {
            addLeftPanelViewController()
        }

        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }

    func addLeftPanelViewController() {
        guard leftViewController == nil else { return }

        if let viewController = UIStoryboard.leftViewController() {
            addChildSidePanelController(viewController)
            leftViewController = viewController
        }
    }

    func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(
                targetPosition: centerViewController.view.frame.width - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: .zero) { _ in
                self.currentState = .bothCollapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }

    func toggleRightPanel() {
        let notAlreadyExpanded = (currentState != .rightPanelExpanded)

        if notAlreadyExpanded {
            addRightPanelViewController()
        }

        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }

    func addRightPanelViewController() {
        guard rightViewController == nil else { return }

        if let viewController = UIStoryboard.rightViewController() {
            addChildSidePanelController(viewController)
            rightViewController = viewController
        }
    }

    func animateRightPanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .rightPanelExpanded
            animateCenterPanelXPosition(
                targetPosition: -centerViewController.view.frame.width + centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: .zero) { _ in
                self.currentState = .bothCollapsed

                self.rightViewController?.view.removeFromSuperview()
                self.rightViewController = nil
            }
        }
    }

    func collapseSidePanels() {
        switch currentState {
        case .rightPanelExpanded:
            toggleRightPanel()
        case .leftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }

    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5,
                       delay: .zero,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: .zero,
                       options: .curveEaseInOut, animations: {
                        self.centerViewController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }

    func addChildSidePanelController(_ sidePanelController: UIViewController) {
        view.insertSubview(sidePanelController.view, at: .zero)

        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
    }

    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            centerViewController.view.layer.shadowOpacity = 0.8
        } else {
            centerViewController.view.layer.shadowOpacity = .zero
        }
    }
}

// MARK: Gesture recognizer

extension ContainerViewController: UIGestureRecognizerDelegate {
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > .zero)

        switch recognizer.state {
        case .began:
            if currentState == .bothCollapsed {
                if gestureIsDraggingFromLeftToRight {
                    addLeftPanelViewController()
                } else {
                    addRightPanelViewController()
                }

                showShadowForCenterViewController(true)
            }

        case .changed:
            if let rview = recognizer.view {
                rview.center.x += recognizer.translation(in: view).x
                recognizer.setTranslation(CGPoint.zero, in: view)
            }

        case .ended:
            if leftViewController != nil,
                let rview = recognizer.view {
                // animate the side panel open or closed based on whether the view
                // has moved more or less than halfway
                let hasMovedGreaterThanHalfway = rview.center.x > view.bounds.size.width
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
            } else if rightViewController != nil,
                let rview = recognizer.view {
                let hasMovedGreaterThanHalfway = rview.center.x < .zero
                animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }

        default:
            break
        }
    }
}
