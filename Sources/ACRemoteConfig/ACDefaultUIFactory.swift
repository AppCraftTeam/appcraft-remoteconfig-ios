//
//  ACDefaultUIFactory.swift
//
//
//  Created by Pavel Moslienko on 05.09.2024.
//

import UIKit

public class ACDefaultUIFactory: ACVerifyUIFactory {
    
    public var style = ACVerifyApplicationAvailabilityStyle()
    public var configuration: ACDefaultUIConfiguration = .default()
    
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
    
    public func makeIosActualVersionAlert(tapOpenStore: (() -> Void)?, tapContinueWithoutUpdating: (() -> Void)?) -> UIViewController {
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
}
