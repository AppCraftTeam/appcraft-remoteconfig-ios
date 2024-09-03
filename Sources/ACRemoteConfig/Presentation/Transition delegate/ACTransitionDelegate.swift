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

public class ACTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    let cornerRadius: CGFloat
    let size: ACPresentationControllerSize
    let animationDuration: TimeInterval
    let backgroundFactory: ACCustomPresentationBackgroundFactory
    
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
        
    // MARK: Presentation controller
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
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ACPresentAnimation(duration: animationDuration)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ACDismissAnimation()
    }
}
