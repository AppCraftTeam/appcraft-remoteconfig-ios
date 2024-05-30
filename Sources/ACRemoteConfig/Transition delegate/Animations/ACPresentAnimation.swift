//
//  ACPresentAnimation.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit
import Foundation

class ACPresentAnimation: NSObject {
    
    let duration: TimeInterval
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
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
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = animator(using: transitionContext)
        animator?.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard let animator = animator(using: transitionContext) else {
            return UIViewPropertyAnimator()
        }
        return animator
    }
}
