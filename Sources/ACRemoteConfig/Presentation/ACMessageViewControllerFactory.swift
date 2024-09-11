//
//  ACMessageViewControllerFactory.swift
//
//
//  Created by Pavel Moslienko on 05.09.2024.
//

import UIKit

/// A default implementation of the `ACVerifyUIFactory` protocol
public class ACMessageViewControllerFactory: ACVerifyUIFactory {
    
    /// The configuration settings for the default UI components
    public var viewModel: ACMessageViewModel
    
    // MARK: - Initialization
    
    /// Initializes the default UI factory
    public init(viewModel: ACMessageViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Alert Factory Helper
    
    /// A helper method to create a message view controller
    /// - Parameters:
    ///   - title: The title text
    ///   - message: The message otext
    ///   - actions: An array of buttons to display
    private func makeScreen(title: String?, message: String?, actions: [ACMessageViewController.ActionModel]) -> UIViewController {
        let viewController = ACMessageViewController()
        viewController.titleText = title ?? ""
        viewController.subtitleText = message ?? ""
        viewController.addActions(actions)
        return viewController
    }
    
    // MARK: - Alert Factories
    
    /// Creates a technical works screen
    /// - Parameter tapTryAgain: The action to perform when the user taps the "Try Again" button
    public func makeTechnicalWorksAlert(tapTryAgain: (() -> Void)?) -> UIViewController {
        return makeScreen(
            title: viewModel.localeConfiguration.technicalWorksAlertTitle,
            message: viewModel.localeConfiguration.technicalWorksAlertMessage,
            actions: [
                .init(
                    text: viewModel.localeConfiguration.tryAgainAlertActionTitle,
                    action: { tapTryAgain?() }
                )
            ]
        )
    }
    
    /// Creates an alert for when the app's version is below the minimum required version
    /// - Parameter tapOpenStore: The action to perform when the user taps the button to open the App Store
    public func makeIosMinimalVersionAlert(tapOpenStore: (() -> Void)?) -> UIViewController {
        return makeScreen(
            title: viewModel.localeConfiguration.iosMinimalVersionAlertTitle,
            message: viewModel.localeConfiguration.iosMinimalVersionAlertMessage,
            actions: [
                .init(
                    text: viewModel.localeConfiguration.appUpdateAlertActionTitle,
                    action: { tapOpenStore?() }
                )
            ]
        )
    }
    
    /// Creates an alert for when the app's version is below the current available version, with options
    /// to update or continue without updating
    /// - Parameters:
    ///   - tapOpenStore: The action to perform when the user chooses to open the App Store for the update
    ///   - tapContinueWithoutUpdating: The action to perform when the user chooses to continue without updating
    public func makeIosActualVersionAlert(
        tapOpenStore: (() -> Void)?,
        tapContinueWithoutUpdating: (() -> Void)?
    ) -> UIViewController {
        return makeScreen(
            title: viewModel.localeConfiguration.iosActualVersionAlertTitle,
            message: viewModel.localeConfiguration.iosActualVersionAlertMessage,
            actions: [
                .init(
                    text: viewModel.localeConfiguration.appUpdateAlertActionTitle,
                    action: { tapOpenStore?() }
                ),
                .init(
                    text: viewModel.localeConfiguration.continueWithoutUpdatingAlertActionTitle,
                    action: { tapContinueWithoutUpdating?() }
                )
            ]
        )
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
        
        viewController.modalPresentationStyle = .fullScreen
        parentViewController?.present(viewController, animated: true, completion: nil)
    }
}
