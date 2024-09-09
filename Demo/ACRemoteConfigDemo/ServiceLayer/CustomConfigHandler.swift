//
//  CustomConfigHandler.swift
//  ACRemoteConfigDemo
//
//  Created by Pavel Moslienko on 06.09.2024.
//

import ACRemoteConfig
import UIKit

open class CustomConfigHandler: ACVerifyApplicationAvailability {
    
    open override func showTechnicalWorksAlert(didTryAgain: (() -> Void)?, completion: VerifyCompletion?) {
        showAlert()
        
        func showAlert() {
            let alert = UIAlertController(title: "Technical Works", message: "Please, try later", preferredStyle: .alert)
            
            let tryAgainAction = UIAlertAction(title: "Try again", style: .default) { _ in
                showAlert()
                didTryAgain?()
            }
            
            alert.addAction(tryAgainAction)
            
            viewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    open override func showIosMinimalVersionAlert(completion: VerifyCompletion?) {
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
            
            viewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    open override func showIosActualVersionAlert(completion: VerifyCompletion?) {
        // Ignore actual
        completion?(true)
    }
}

// MARK: - UI
private extension CustomConfigHandler {
    
    func openAppInAppStore(completion: ((Bool) -> Void)?) {
        guard let url = self.configuration.urlToAppInAppStore else {
            print("[ACVerifyApplicationAvailability] - [openAppUpdate] - urlToAppInAppStore == nil")
            completion?(false)
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
}
