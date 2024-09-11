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
    
    /// URL for open app page in App Store
    open var urlToAppInAppStore: URL?
    
    /// A custom factory for creating screen
    open var customUIFactory: ACVerifyUIFactory
    
    // MARK: - Initialization
    
    /// Initializes the verifier
    /// - Parameters:
    ///   - viewController: The parent view controller from screens will be presented
    ///   - urlToAppInAppStore: URL for open app page in App Store
    ///   - customUIFactory: A custom factory for creating screen
    public init(
        viewController: UIViewController? = nil,
        urlToAppInAppStore: URL? = nil,
        customUIFactory: ACVerifyUIFactory? = nil
    ) {
        self.viewController = viewController
        self.urlToAppInAppStore = urlToAppInAppStore
        self.customUIFactory = customUIFactory ?? ACMessageViewControllerFactory(
            viewModel: ACMessageViewModel(
                actions: [],
                localeConfiguration: .default()
            )
        )
    }
    
    /// Performs the verification process
    /// - Parameters:
    ///   - model: The remote configuration model
    ///   - completion: Called with `true` if verification passed
    ///   - didTryAgain: Called if the user taps "Try Again"
    open func verify(fromModel model: ACRemoteConfig?, completion: VerifyCompletion?, didTryAgain: (() -> Void)?) {
        guard let model = model else {
            completeVerification(completion)
            return
        }
        
        if model.technicalWorks {
            // Show technical works alert if the server is under maintenance
            presentAlert(makeAlert: customUIFactory.makeTechnicalWorksAlert(tapTryAgain: {
                didTryAgain?()
                completion?(false)
            }), completion: completion)
        } else if let appVersion = getAppVersion() {
            // Check if the app version can be retrieved
            checkVersion(appVersion, model: model, completion: completion)
        } else {
            completeVerification(completion)
        }
    }
    
    /// Check app version and show the appropriate alert
    private func checkVersion(_ appVersion: String, model: ACRemoteConfig, completion: VerifyCompletion?) {
        if isVersionLower(appVersion, than: model.iosMinimalVersion) {
            presentAlert(
                makeAlert: customUIFactory.makeIosMinimalVersionAlert {
                    self.openAppInAppStore { isSuccess in
                        completion?(isSuccess)
                    }
                },
                completion: completion
            )
        } else if isVersionLower(appVersion, than: model.iosActualVersion) {
            presentAlert(
                makeAlert: customUIFactory.makeIosActualVersionAlert(
                    tapOpenStore: {
                        self.openAppInAppStore { isSuccess in
                            completion?(false)
                        }
                    },
                    tapContinueWithoutUpdating: {
                        self.viewController?.topMostViewController().dismiss(animated: true)
                        completion?(true)
                    }
                ),
                completion: completion
            )
        } else {
            completeVerification(completion)
        }
    }
    
    // MARK: - Version Helper
    
    /// Retrieves the app's version and build number from the Info.plist.
    open func getAppVersion() -> String? {
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
    open func isVersionLower(_ currentVersion: String, than requiredVersion: String) -> Bool {
        currentVersion.compare(requiredVersion, options: .numeric) == .orderedAscending
    }
    
    // MARK: - App Store Helpers
    
    /// Open App Store to the app page
    open func openAppInAppStore(completion: ((Bool) -> Void)?) {
        guard let url = self.urlToAppInAppStore else {
            print("[ACVerifyApplicationAvailability] - [openAppUpdate] - urlToAppInAppStore == nil")
            completion?(false)
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }

    /// Presents a view controller for an alert
    open func presentAlert(makeAlert: UIViewController, completion: VerifyCompletion?) {
        customUIFactory.presentViewController(makeAlert, from: viewController)
    }
    
    /// Completes the verification process
    open func completeVerification(_ completion: VerifyCompletion?) {
        if let presentedVc = viewController?.topMostViewController() as? ACMessageViewControllerProtocol {
            presentedVc.dismiss(animated: true) {
                completion?(true)
            }
        } else {
            completion?(true)
        }
    }
}
