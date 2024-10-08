//
//  CustomVerifyUiFactory.swift
//  ACRemoteConfigDemo
//
//  Created by Pavel Moslienko on 06.09.2024.
//

import ACRemoteConfig
import UIKit

final class CustomVerifyViewControllerFactory: ACVerifyViewControllerFactory {
    
    public var minAppVersion: String
    public var actualAppVersion: String

    public init(
        minAppVersion: String = "",
        actualAppVersion: String = ""
    ) {
        self.minAppVersion = minAppVersion
        self.actualAppVersion = actualAppVersion
    }
    
    public func makeTechnicalWorksAlert(tapTryAgain: (() -> Void)?) -> UIViewController {
        let viewController = CustomVerificationViewController()
        viewController.model = CustomVerificationViewModel(mode: .techWorks)
        viewController.model.onRepeatTapped = {
            tapTryAgain?()
        }
        
        return viewController
    }
    
    public func makeIosMinimalVersionAlert(tapOpenStore: (() -> Void)?) -> UIViewController {
        let viewController = CustomVerificationViewController()
        viewController.model = CustomVerificationViewModel(mode: .needToUpdate(to: minAppVersion))
        viewController.model.onOpenStoreTapped = {
            tapOpenStore?()
        }
        
        return viewController
    }
    
    public func makeIosActualVersionAlert(tapOpenStore: (() -> Void)?, tapContinueWithoutUpdating: (() -> Void)?) -> UIViewController {
        let viewController = CustomVerificationViewController()
        viewController.model = CustomVerificationViewModel(mode: .possibleToUpdate(to: actualAppVersion))
        viewController.model.onOpenStoreTapped = {
            tapOpenStore?()
        }
        viewController.model.onContinueTapped = {
            tapContinueWithoutUpdating?()
        }
        return viewController
    }
    
    public func presentViewController(_ viewController: UIViewController, from parentViewController: UIViewController?) {
        viewController.modalPresentationStyle = .fullScreen
        parentViewController?.present(viewController, animated: true, completion: nil)
    }
}
