//
//  CustomConfigHandler.swift
//  ACRemoteConfigDemo
//
//  Created by Pavel Moslienko on 06.09.2024.
//

import ACRemoteConfig
import UIKit

open class CustomConfigHandler: ACVerifyApplicationAvailability {
    
    open override func verify(fromModel model: ACRemoteConfig?, completion: VerifyCompletion?, didTryAgain: (() -> Void)?) {
        guard let model = model else {
            completion?(true)
            return
        }
        
        if model.technicalWorks {
            showTechnicalWorksAlert(didTryAgain: {
                didTryAgain?()
                completion?(false)
            }, completion: completion)
        } else if let appVersion = getAppVersion() {
            if isVersionLower(appVersion, than: model.iosMinimalVersion) {
                showIosMinimalVersionAlert(completion: completion)
            } else {
                completeVerification(completion)
            }
        } else {
            completion?(true)
        }
    }
    
    private func showTechnicalWorksAlert(didTryAgain: (() -> Void)?, completion: VerifyCompletion?) {
        showAlert()
        
        func showAlert() {
            let alert = UIAlertController(title: "Technical Works", message: "Please, try later", preferredStyle: .alert)
            
            let tryAgainAction = UIAlertAction(title: "Try again", style: .default) { _ in
                showAlert()
                didTryAgain?()
            }
            
            alert.addAction(tryAgainAction)
            
            parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showIosMinimalVersionAlert(completion: VerifyCompletion?) {
        showAlert()
        
        func showAlert() {
            let alert = UIAlertController(title: "New version available", message: nil, preferredStyle: .alert)
            
            let tryAgainAction = UIAlertAction(title: "Open App Store", style: .default) { _ in
                showAlert()
                self.openAppInAppStore { result in
                    completion?(result)
                }
            }
            
            alert.addAction(tryAgainAction)
            
            parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
