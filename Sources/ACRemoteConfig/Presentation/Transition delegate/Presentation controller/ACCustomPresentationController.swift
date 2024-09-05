//
//  ACCustomPresentationController.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit

/// A subclass of `ACPresentationController` that adds a customizable background view behind the presented view controller
class ACCustomPresentationController: ACPresentationController {
    
    /// The view used as the background behind the presented view controller
    private var backgroundView: UIView
    
    /// Initializes the custom presentation controller
    /// - Parameters:
    ///   - presentedViewController: The view controller being presented.
    ///   - presenting: The view controller responsible for presenting the `presentedViewController`
    ///   - driver: A `UIPercentDrivenInteractiveTransition` instance used for interactive transitions
    ///   - backgroundFactory: A factory that provides the background view for the presentation
    init(
        presentedViewController: UIViewController,
        presenting: UIViewController?,
        driver: UIPercentDrivenInteractiveTransition,
        backgroundFactory: ACCustomPresentationBackgroundFactory = BSDimmBackgroundViewFactory()
    ) {
        self.backgroundView = backgroundFactory.backgroundView()
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }
    
    /// Called when the presentation transition is about to begin
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        self.containerView?.insertSubview(backgroundView, at: 0)
        self.performAlongsideTransitionIfPossible { [unowned self] in
            self.backgroundView.alpha = 1
        }
    }
    
    /// Adjusts the layout of the background view and presented view when the container view's bounds change
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        guard let containerView = containerView else {
            return
        }
        self.backgroundView.frame = containerView.frame
    }
    
    /// Called when the presentation transition ends
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            self.backgroundView.removeFromSuperview()
        }
    }
    
    /// Called when the dismissal transition is about to begin
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        self.performAlongsideTransitionIfPossible { [unowned self] in
            self.backgroundView.alpha = 0
        }
    }
    
    /// Called when the dismissal transition ends
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            self.backgroundView.removeFromSuperview()
        }
    }
    
    /// Performs the animation alongside the presentation or dismissal transition
    private func performAlongsideTransitionIfPossible(_ block: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            block()
            return
        }
        coordinator.animate(
            alongsideTransition: { (_) in
                block()
            },
            completion: nil
        )
    }
}
