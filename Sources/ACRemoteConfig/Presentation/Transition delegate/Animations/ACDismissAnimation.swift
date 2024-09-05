//
//  ACDismissAnimation.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit

/// Handle the dismissal animation of a view controller
class ACDismissAnimation: NSObject {
    
    /// The duration of the dismissal animation
    let duration: TimeInterval = 0.3
    
    /// Creates and returns a property animator to handle the dismissal transition.
    /// - Parameter transitionContext: The context object containing information about the transition.
    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating? {
        guard let from = transitionContext.view(forKey: .from),
              let viewController = transitionContext.viewController(forKey: .from) else {
            return nil
        }
        
        // Get the initial frame of the view being dismissed
        let initialFrame = transitionContext.initialFrame(for: viewController)
        
        // Create a property animator to animate the slide-down effect
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            from.frame = initialFrame.offsetBy(dx: 0, dy: initialFrame.height)
        }
        
        // Add completion handler to finalize the transition
        animator.addCompletion { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        return animator
    }
}

// MARK: - UIViewControllerAnimatedTransitioning mehtods
extension ACDismissAnimation: UIViewControllerAnimatedTransitioning {
    
    /// Returns the duration of the transition animation
    /// - Parameter transitionContext: The context object containing information about the transition
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    /// Performs the transition animation.
    /// - Parameter transitionContext: The context object containing information about the transition
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
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
