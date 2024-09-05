//
//  ACTransitionDelegate.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics

/// Managing the transition and presentation style of view controllers
public class ACTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    /// The corner radius applied to the presented view controller.
    let cornerRadius: CGFloat
    
    /// The size of the presented view controller
    let size: ACPresentationControllerSize
    
    /// The duration of the transition animation
    let animationDuration: TimeInterval
    
    /// A factory object responsible for creating the background view behind the presented view controller
    let backgroundFactory: ACCustomPresentationBackgroundFactory
    
    /// Initializes the transition delegate
    /// - Parameters:
    ///   - cornerRadius: The corner radius to be applied to the presented view controller
    ///   - animationDuration: The duration of the transition animation
    ///   - size: The size configuration of the presented view controller
    ///   - backgroundFactory: A factory object that provides the background view behind the presented view controller
    init(
        cornerRadius: CGFloat = 16,
        animationDuration: TimeInterval = 0.25,
        size: ACPresentationControllerSize = .percent(value: 0.8),
        backgroundFactory: ACCustomPresentationBackgroundFactory = BSDimmBackgroundViewFactory()
    ) {
        self.size = size
        self.cornerRadius = cornerRadius
        self.animationDuration = animationDuration
        self.backgroundFactory = backgroundFactory
    }
    
    // MARK: - Presentation controller
    
    /// Returns a custom presentation controller for the presented view controller.
    /// - Parameters:
    ///   - presented: The view controller being presented
    ///   - presenting: The view controller that is presenting the `presented` view controller
    ///   - source: The original view controller that initiated the presentation
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = ACCustomPresentationController(
            presentedViewController: presented,
            presenting: presenting ?? source,
            driver: .init(),
            backgroundFactory: backgroundFactory
        )
        presentationController.size = size
        presentationController.cornerRadius = cornerRadius
        return presentationController
    }
    
    // MARK: - Animation
    
    /// Provides the animation controller for presenting the view controller
    /// - Parameters:
    ///   - presented: The view controller being presented
    ///   - presenting: The view controller that is presenting
    ///   - source: The source view controller that triggered the presentation
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ACPresentAnimation(duration: animationDuration)
    }
    
    /// Provides the animation controller for dismissing the view controller
    /// - Parameter dismissed: The view controller being dismissed
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ACDismissAnimation()
    }
}
