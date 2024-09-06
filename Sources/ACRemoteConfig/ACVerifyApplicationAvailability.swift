import Foundation
import UIKit

/// A class responsible for verifying the availability of the application, including checks for
/// technical works, minimum required version, and available updates
open class ACVerifyApplicationAvailability: ACVerifyHandler {
    
    /// Completion handler type alias for the verification process.
    public typealias VerifyCompletion = (Bool) -> Void
    
    // MARK: - Properties
    
    /// Parent view controller from screen will be presented
    open weak var viewController: UIViewController?
    
    /// Configuration settings
    open var configuration: ACVerifyConfiguration
    
    /// A custom factory for creating screen
    open var customUIFactory: ACVerifyUIFactory
    
    // MARK: - Initialization
    
    /// Initializes the verifier
    /// - Parameters:
    ///   - viewController: The parent view controller from screens will be presented
    ///   - style: The style configuration
    ///   - configuration: The configuration object
    ///   - customUIFactory: A custom factory for creating screen
    public init(
        viewController: UIViewController? = nil,
        style: ACVerifyApplicationAvailabilityStyle = ACVerifyApplicationAvailabilityStyle(),
        configuration: ACVerifyConfiguration,
        customUIFactory: ACVerifyUIFactory? = nil
    ) {
        self.viewController = viewController
        self.configuration = configuration
        self.customUIFactory = customUIFactory ?? ACDefaultUIFactory(style: style)
    }
    
    /// Performs the verification process
    /// - Parameters:
    ///   - model: The remote configuration model
    ///   - completion: Called with `true` if verification passed
    ///   - didTryAgain: Called if the user taps "Try Again"
    open func verify(fromModel model: ACRemoteConfig?, completion: VerifyCompletion?, didTryAgain: (() -> Void)?) {
        guard let model = model else {
            completion?(true)
            return
        }
        
        // Show technical works alert if the server is under maintenance
        if model.technicalWorks {
            showTechnicalWorksAlert(didTryAgain: didTryAgain, completion: completion)
            return
        }
        
        // Check if the app version can be retrieved
        guard let appVersionFull = getAppVersion() else {
            completion?(true)
            return
        }
        
        // Show alerts based on the version check
        if isVersionLower(appVersionFull, than: model.iosMinimalVersion) {
            showIosMinimalVersionAlert(completion: completion)
        } else if isVersionLower(appVersionFull, than: model.iosActualVersion) {
            showIosActualVersionAlert(completion: completion)
        } else {
            completion?(true)
        }
    }
    
    /// Shows an alert indicating the app is undergoing technical maintenance
    /// - Parameters:
    ///   - didTryAgain: Called if the user chooses to retry
    open func showTechnicalWorksAlert(didTryAgain: (() -> Void)?, completion: VerifyCompletion?) {
        customUIFactory.presentViewController(
            customUIFactory.makeTechnicalWorksAlert(tapTryAgain: {
                didTryAgain?()
                completion?(false)
            }), from: self.viewController
        )
    }
    
    /// Shows an alert prompting the user to update the app to the minimum required version
    open func showIosMinimalVersionAlert(completion: VerifyCompletion?) {
        customUIFactory.presentViewController(
            customUIFactory.makeIosMinimalVersionAlert(tapOpenStore: {
                self.openAppInAppStore { _ in
                    completion?(false)
                }
            }),
            from: self.viewController
        )
    }
    
    /// Shows an alert informing the user that an update is available
    open func showIosActualVersionAlert(completion: VerifyCompletion?) {
        customUIFactory.presentViewController(
            customUIFactory.makeIosActualVersionAlert(tapOpenStore: {
                self.openAppInAppStore { _ in
                    completion?(false)
                }
            }, tapContinueWithoutUpdating: { [weak viewController] in
                viewController?.dismiss(animated: true)
                completion?(true)
            }),
            from: self.viewController
        )
    }
}

// MARK: - Version Helper
private extension ACVerifyApplicationAvailability {
    
    /// Retrieves the app's version and build number from the Info.plist.
    func getAppVersion() -> String? {
        guard
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        else {
            return nil
        }
        return "\(appVersion).\(buildNumber)"
    }
    
    /// Compares the current app version with the required version
    /// - Parameters:
    ///   - currentVersion: The current app version
    ///   - requiredVersion: The required app version
    /// - Returns: `true` if the current version is lower than the required version
    func isVersionLower(_ currentVersion: String, than requiredVersion: String) -> Bool {
        return currentVersion.compare(requiredVersion, options: .numeric) == .orderedAscending
    }
}

// MARK: - App Store Helpers
private extension ACVerifyApplicationAvailability {
    
    /// Open App Store to the app page
    func openAppInAppStore(completion: ((Bool) -> Void)?) {
        guard let url = self.configuration.urlToAppInAppStore else {
            print("[ACVerifyApplicationAvailability] - [openAppUpdate] - urlToAppInAppStore == nil")
            completion?(false)
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
}
