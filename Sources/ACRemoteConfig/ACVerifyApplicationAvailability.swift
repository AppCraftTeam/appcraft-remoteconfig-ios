import Foundation
import UIKit

open class ACVerifyApplicationAvailability: ACVerifyHandler {
    
    public typealias VerifyCompletion = (Bool) -> Void
    
    // MARK: - Props
    open weak var viewController: UIViewController?
    open var configuration: ACVerifyConfiguration
    open var customUIFactory: ACVerifyUIFactory
    
    // MARK: - Init
    public init(viewController: UIViewController? = nil,
                style: ACVerifyApplicationAvailabilityStyle = ACVerifyApplicationAvailabilityStyle(),
                configuration: ACVerifyConfiguration,
                customUIFactory: ACVerifyUIFactory? = nil) {
        self.viewController = viewController
        self.configuration = configuration
        self.customUIFactory = customUIFactory ?? ACDefaultUIFactory(style: style)
    }
    
    open func verify(fromModel model: ACRemoteConfig?, completion: VerifyCompletion?, didTryAgain: (() -> Void)?) {
        guard let model = model else {
            completion?(true)
            return
        }
        
        if model.technicalWorks {
            showTechnicalWorksAlert(didTryAgain: didTryAgain, completion: completion)
            return
        }
        
        guard let appVersionFull = getAppVersion() else {
            completion?(true)
            return
        }
        
        if isVersionLower(appVersionFull, than: model.iosMinimalVersion) {
            showIosMinimalVersionAlert(completion: completion)
        } else if isVersionLower(appVersionFull, than: model.iosActualVersion) {
            showIosActualVersionAlert(completion: completion)
        } else {
            completion?(true)
        }
    }
    
    private func showTechnicalWorksAlert(didTryAgain: (() -> Void)?, completion: VerifyCompletion?) {
        customUIFactory.presentViewController(
            customUIFactory.makeTechnicalWorksAlert(tapTryAgain: {
                didTryAgain?()
                completion?(false)
            }), from: self.viewController
        )
    }
    
    private func showIosMinimalVersionAlert(completion: VerifyCompletion?) {
        customUIFactory.presentViewController(
            customUIFactory.makeIosMinimalVersionAlert(tapOpenStore: {
                self.openAppInAppStore { _ in
                    completion?(false)
                }
            }),
            from: self.viewController
        )
    }
    
    private func showIosActualVersionAlert(completion: VerifyCompletion?) {
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

// MARK: - Version helper
private extension ACVerifyApplicationAvailability {
    
    func getAppVersion() -> String? {
        guard
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        else {
            return nil
        }
        return "\(appVersion).\(buildNumber)"
    }
    
    func isVersionLower(_ currentVersion: String, than requiredVersion: String) -> Bool {
        return currentVersion.compare(requiredVersion, options: .numeric) == .orderedAscending
    }
}

// MARK: - UI
private extension ACVerifyApplicationAvailability {
    
    func openAppInAppStore(completion: ((Bool) -> Void)?) {
        guard let url = self.configuration.urlToAppInAppStore else {
            print("[ACVerifyApplicationAvailability] - [openAppUpdate] - urlToAppInAppStore == nil")
            completion?(false)
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
}
