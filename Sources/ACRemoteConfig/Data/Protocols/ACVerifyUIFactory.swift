//
//  ACVerifyUIFactory.swift
//
//
//  Created by Pavel Moslienko on 05.09.2024.
//

import Foundation
import UIKit

/// Protocol defining the UI factory for generating screens for verification process
public protocol ACVerifyUIFactory {
    
    /// The style to be applied to the UI components
    var style: ACVerifyApplicationAvailabilityStyle { get set }
    
    /// Creates a technical works screen
    /// - Parameter tapTryAgain: The action to perform when the user taps the "Try Again" button
    func makeTechnicalWorksAlert(tapTryAgain: (() -> Void)?) -> UIViewController
    
    /// Creates an screen for when the apps version is below the minimum required version
    /// - Parameter tapOpenStore: The action to perform when the user taps the button to open the App Store
    func makeIosMinimalVersionAlert(tapOpenStore: (() -> Void)?) -> UIViewController
    
    /// Creates an screen for when the apps version is below the current available version, with options
    /// to update or continue without updating
    /// - Parameters:
    ///   - tapOpenStore: The action to perform when the user chooses to open the App Store for the update
    ///   - tapContinueWithoutUpdating: The action to perform when the user chooses to continue without updating
    func makeIosActualVersionAlert(tapOpenStore: (() -> Void)?, tapContinueWithoutUpdating: (() -> Void)?) -> UIViewController
    
    /// Presents a view controller
    /// - Parameters:
    ///   - viewController: The view controller to present
    ///   - parentViewController: The parent view controller from which to present the new view controller
    func presentViewController(_ viewController: UIViewController, from parentViewController: UIViewController?)
}