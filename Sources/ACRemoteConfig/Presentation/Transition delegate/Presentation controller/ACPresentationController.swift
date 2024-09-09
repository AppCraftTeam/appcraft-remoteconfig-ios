//
//  ACPresentationController.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit
import CoreGraphics

/// A custom presentation controller that manages the layout and appearance of the presented view controller
class ACPresentationController: UIPresentationController {
    
    /// The corner radius applied to the top corners of the presented view
    var cornerRadius: CGFloat = 0.0
    
    /// Defines the size of the presented view
    var size: ACPresentationControllerSize = .percent(value: 1.0)
    
    /// Indicates whether the presented view should be in fullscreen
    override var shouldPresentInFullscreen: Bool {
        false
    }
    
    /// Calculates and returns the frame of the presented view within the container view
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
    
    /// Called when the presentation transition is about to begin
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let presentedView = presentedView else {
            return
        }
        self.containerView?.addSubview(presentedView)
    }
    
    /// Adjusts the layout of the presented view when the container view's bounds change
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
    
    /// Initializes the presentation controller
    override init(presentedViewController: UIViewController, presenting: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }
    
    /// Called after the presentation transition completes
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
    }
}
