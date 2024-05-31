//
//  ACCustomPresentationController.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit

class ACCustomPresentationController: ACPresentationController {
    
    private var backgroundView: UIView
    
    init(
        presentedViewController: UIViewController,
        presenting: UIViewController?,
        driver: UIPercentDrivenInteractiveTransition,
        backgroundFactory: ACCustomPresentationBackgroundFactory = BSDimmBackgroundViewFactory()
    ) {
        self.backgroundView = backgroundFactory.backgroundView()
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        self.containerView?.insertSubview(backgroundView, at: 0)
        self.performAlongsideTransitionIfPossible { [unowned self] in
            self.backgroundView.alpha = 1
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        guard let containerView = containerView else {
            return
        }
        self.backgroundView.frame = containerView.frame
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            self.backgroundView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        self.performAlongsideTransitionIfPossible { [unowned self] in
            self.backgroundView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            self.backgroundView.removeFromSuperview()
        }
    }
    
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
