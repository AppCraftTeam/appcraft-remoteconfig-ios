//
//  ACPresentAnimation.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit
import Foundation

/// Handles the presentation animation of a view controller
class ACPresentAnimation: NSObject {
    
    /// The duration of the transition animation in seconds
    let duration: TimeInterval
    
    /// Initializes the `ACPresentAnimation`
    /// - Parameter duration: The duration of the animation
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    /// Creates and returns a property animator to handle the presentation transition
    /// - Parameter transitionContext: The context object containing information about the transition
    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating? {
        guard let to = transitionContext.view(forKey: .to), let viewController = transitionContext.viewController(forKey: .to) else {
            return nil
        }
        // Move controller off the screen
        let finalFrame = transitionContext.finalFrame(for: viewController)
        to.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            // Return to base position
            to.frame = finalFrame
        }
        animator.addCompletion { (_) in
            // End the transition if it hasn't been canceled
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        return animator
    }
}

// MARK: - UIViewControllerAnimatedTransitioning mehtods
extension ACPresentAnimation: UIViewControllerAnimatedTransitioning {
    /// Returns the duration of the transition animation
    /// - Parameter transitionContext: The context object containing information about the transition
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    /// Performs the transition animation.
    /// - Parameter transitionContext: The context object containing information about the transition
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = animator(using: transitionContext)
        animator?.startAnimation()
    }
    
    /// Returns an interruptible animator object
    /// - Parameter transitionContext: The context object containing information about the transition
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard let animator = animator(using: transitionContext) else {
            return UIViewPropertyAnimator()
        }
        return animator
    }
}
