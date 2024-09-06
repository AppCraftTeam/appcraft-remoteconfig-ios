//
//  ACDefaultUIFactory.swift
//
//
//  Created by Pavel Moslienko on 05.09.2024.
//

import UIKit

/// A default implementation of the `ACVerifyUIFactory` protocol
public class ACDefaultUIFactory: ACVerifyUIFactory {
    
    /// The style configuration that defines the appearance of the UI elements
    public var style: ACVerifyApplicationAvailabilityStyle
    
    /// The configuration settings for the default UI components
    public var configuration: ACDefaultUIConfiguration
    
    // MARK: - Initialization
    
    /// Initializes the default UI factory
    /// - Parameters:
    ///   - style: The style settings for UI elements
    ///   - configuration: The configuration settings
    public init(
        style: ACVerifyApplicationAvailabilityStyle = ACVerifyApplicationAvailabilityStyle(),
        configuration: ACDefaultUIConfiguration = .default()
    ) {
        self.style = style
        self.configuration = configuration
    }
    
    // MARK: - Alert Factories
    
    /// Creates a technical works screen
    /// - Parameter tapTryAgain: The action to perform when the user taps the "Try Again" button
    public func makeTechnicalWorksAlert(tapTryAgain: (() -> Void)?) -> UIViewController {
        let viewController = style.viewControllerFactory.make()
        viewController.titleText = configuration.technicalWorksAlertTitle ?? ""
        viewController.subtitleText = configuration.technicalWorksAlertMessage ?? ""
        
        viewController.addActions([
            .init(
                text: configuration.tryAgainAlertActionTitle,
                style: style.technicalWorkButtonStyle,
                action: {
                    tapTryAgain?()
                }
            )
        ])
        
        return viewController
    }
    
    /// Creates an screen for when the apps version is below the minimum required version
    /// - Parameter tapOpenStore: The action to perform when the user taps the button to open the App Store
    public func makeIosMinimalVersionAlert(tapOpenStore: (() -> Void)?) -> UIViewController {
        let viewController = style.viewControllerFactory.make()
        viewController.titleText = configuration.iosMinimalVersionAlertTitle ?? ""
        viewController.subtitleText = configuration.iosMinimalVersionAlertMessage ?? ""
        
        viewController.addActions([
            .init(
                text: self.configuration.appUpdateAlertActionTitle,
                style: self.style.minimalVersionButtonStyle,
                action: {
                    tapOpenStore?()
                }
            )
        ])
        
        return viewController
    }
    
    /// Creates an screen for when the apps version is below the current available version, with options
    /// to update or continue without updating
    /// - Parameters:
    ///   - tapOpenStore: The action to perform when the user chooses to open the App Store for the update
    ///   - tapContinueWithoutUpdating: The action to perform when the user chooses to continue without updating
    public func makeIosActualVersionAlert(
        tapOpenStore: (() -> Void)?,
        tapContinueWithoutUpdating: (() -> Void)?
    ) -> UIViewController {
        let viewController = style.viewControllerFactory.make()
        viewController.titleText = configuration.iosActualVersionAlertTitle ?? ""
        viewController.subtitleText = configuration.iosActualVersionAlertMessage ?? ""
        
        viewController.addActions([
            .init(
                text: self.configuration.appUpdateAlertActionTitle,
                style: self.style.actualVersionAproveButtonStyle,
                action: {
                    tapOpenStore?()
                }
            ),
            .init(
                text: self.configuration.continueWithoutUpdatingAlertActionTitle,
                style: self.style.actualVersionCancelButtonStyle,
                action: {
                    tapContinueWithoutUpdating?()
                }
            )
        ])
        
        return viewController
    }
    
    // MARK: - Presentation
    
    /// Presents a view controller
    /// - Parameters:
    ///   - viewController: The view controller to present
    ///   - parentViewController: The parent view controller from which to present the new view controller
    public func presentViewController(_ viewController: UIViewController, from parentViewController: UIViewController?) {
        // Prevents multiple instances of ACMessageViewController from stacking
        if parentViewController?.topMostViewController() is ACMessageViewController {
            return
        }
        
        // Create a custom transition delegate for the presentation
        let transitionDelegate = ACTransitionDelegate(
            cornerRadius: style.presentation.cornerRadius,
            animationDuration: style.presentation.animationDuration,
            size: style.presentation.size,
            backgroundFactory: style.presentation.backgroundFactory
        )
        
        // Apply the custom transitioning and presentation style
        viewController.transitioningDelegate = transitionDelegate
        viewController.modalPresentationStyle = .custom
        parentViewController?.present(viewController, animated: true, completion: nil)
    }
}
