//
//  ACPresentationController.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit
import CoreGraphics

class ACPresentationController: UIPresentationController {
    
    var cornerRadius: CGFloat = 0.0
    var size: ACPresentationControllerSize = .percent(value: 1.0)
    
    override var shouldPresentInFullscreen: Bool {
        false
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else {
            return .zero
        }
        switch size {
        case let .percent(value):
            guard value < 1.0 else {
                return CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
            }
            let height = bounds.height * value
            return CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)
        case let .fixed(size):
            guard size.height <= bounds.height else {
                return CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
            }
            return CGRect(x: 0, y: bounds.height - size.height, width: size.width, height: size.height)
        case let .center(horizontalInset, height):
            return CGRect(x: horizontalInset, y: bounds.height / 2 - height * 0.5, width: bounds.width - horizontalInset * 2, height: height)

        }
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let presentedView = presentedView else {
            return
        }
        self.containerView?.addSubview(presentedView)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
        if cornerRadius > .zero {
            if case ACPresentationControllerSize.center(_, _) = size {
                self.presentedView?.roundCorners(corners: [.allCorners], radius: cornerRadius)
            } else {
                self.presentedView?.roundCorners(corners: [.topLeft, .topRight], radius: cornerRadius)
            }
        }
    }
    
    var driver: BSTransitionDriver
    
    override init(presentedViewController: UIViewController, presenting: UIViewController?) {
        self.driver = BSTransitionDriver()
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }
    
    init(presentedViewController: UIViewController, presenting: UIViewController?, driver: BSTransitionDriver) {
        self.driver = driver
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if completed {
            driver.direction = .dismiss
        }
    }
}


