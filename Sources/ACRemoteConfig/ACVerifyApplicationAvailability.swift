import Foundation
import UIKit
import FirebaseRemoteConfig

open class ACVerifyApplicationAvailability: ACRemoteConfigHandler {
    public typealias VerifyCompletion = (Bool) -> Void
    
    // MARK: - Props
    open weak var viewController: UIViewController?
    open var configuration: Configuration = .default()
    
    // MARK: - Methods
    open func fetchAndVerify(completion: VerifyCompletion?) {
        guard self.fetchAvalible() else {
            completion?(true)
            return
        }
        
        self.fetch { [weak self] error in
            guard let self = self else { return }
            
            guard error == nil else {
                completion?(true)
                return
            }
        
            self.verify(fromModel: RemoteConfigModel(remoteConfig: self.remoteConfig), completion: completion)
        }
    }
    
    open func verify(fromModel model: RemoteConfigModel?, completion: VerifyCompletion?) {
        guard let model = model else {
            completion?(true)
            return
        }

        print("[ACVerifyApplicationAvailability] - [verify] - model:", model)

        guard !model.technicalWorks else {
            print("[ACVerifyApplicationAvailability] - [verify] - technicalWorks")

            self.showTechnicalWorksAlert { [weak self] in
                self?.fetchAndVerify(completion: completion)
            }
            completion?(false)

            return
        }

        guard
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        else {
            completion?(true)
            return
        }

        let appVersionFull = "\(appVersion).\(buildNumber)"
        print("[ACVerifyApplicationAvailability] - [verify] - appVersionFull:", appVersionFull)

        if appVersionFull.compare(model.iosMinimalVersion, options: .numeric) == .orderedAscending {
            print("[ACVerifyApplicationAvailability] - [verify] - iosMinimalVersion - orderedAscending")

            self.showIosMinimalVersionAlert { [weak self] in
                self?.openAppInAppStore { _ in
                    completion?(false)
                }
            }

        } else if appVersionFull.compare(model.iosActualVersion, options: .numeric) == .orderedAscending {
            print("[ACVerifyApplicationAvailability] - [verify] - iosActualVersion - orderedAscending")

            self.showIosActualVersionAlert(
                tapAppUpdate: { [weak self] in
                    self?.openAppInAppStore { _ in
                        completion?(false)
                    }
                },
                tapContinueWithoutUpdating: {
                    completion?(true)
                }
            )

        } else {
            completion?(true)
        }
    }
    
}

// MARK: - Models
public extension ACVerifyApplicationAvailability {
    
    struct RemoteConfigModel: ACRemoteConfigModelProtocol {
        public let iosActualVersion: String
        public let iosMinimalVersion: String
        public let technicalWorks: Bool
        
        public enum CodingKeys: String, CodingKey {
            case iosActualVersion = "iosActualVersion"
            case iosMinimalVersion = "iosMinimalVersion"
            case technicalWorks = "technicalWorks"
        }
        
        public init?(remoteConfig: RemoteConfig) {
            self.iosActualVersion = remoteConfig[CodingKeys.iosActualVersion.rawValue].stringValue ?? ""
            self.iosMinimalVersion = remoteConfig[CodingKeys.iosMinimalVersion.rawValue].stringValue ?? ""
            self.technicalWorks = remoteConfig[CodingKeys.technicalWorks.rawValue].boolValue
        }
        
        public init(
            iosActualVersion: String,
            iosMinimalVersion: String,
            technicalWorks: Bool
        ) {
            self.iosActualVersion = iosActualVersion
            self.iosMinimalVersion = iosMinimalVersion
            self.technicalWorks = technicalWorks
        }
    }
    
    struct Configuration {
        public var urlToAppInAppStore: URL?
        public var technicalWorksAlertTitle: String?
        public var technicalWorksAlertMessage: String?
        public var iosMinimalVersionAlertTitle: String?
        public var iosMinimalVersionAlertMessage: String?
        public var iosActualVersionAlertTitle: String?
        public var iosActualVersionAlertMessage: String?
        public var tryAgainAlertActionTitle: String
        public var continueWithoutUpdatingAlertActionTitle: String
        public var appUpdateAlertActionTitle: String
        
        public static func `default`() -> Configuration {
            func localized(_ key: String) -> String {
                NSLocalizedString(key, bundle: .module, comment: "")
            }
            
            return Configuration(
                urlToAppInAppStore: nil,
                technicalWorksAlertTitle: localized("presenter_configuration_technicalWorksAlertTitle"),
                technicalWorksAlertMessage: localized("presenter_configuration_technicalWorksAlertMessage"),
                iosMinimalVersionAlertTitle: localized("presenter_configuration_iosMinimalVersionAlertTitle"),
                iosMinimalVersionAlertMessage: localized("presenter_configuration_iosMinimalVersionAlertMessage"),
                iosActualVersionAlertTitle: localized("presenter_configuration_iosActualVersionAlertTitle"),
                iosActualVersionAlertMessage: nil,
                tryAgainAlertActionTitle: localized("presenter_configuration_tryAgainAlertActionTitle"),
                continueWithoutUpdatingAlertActionTitle: localized("presenter_configuration_continueWithoutUpdatingAlertActionTitle"),
                appUpdateAlertActionTitle: localized("presenter_configuration_appUpdateAlertActionTitle")
            )
        }
    }
    
}

// MARK: - UI
extension ACVerifyApplicationAvailability {
    
    open func showTechnicalWorksAlert(tapTryAgain: (() -> Void)?) {
        let alert = UIAlertController(
            title: self.configuration.technicalWorksAlertTitle,
            message: self.configuration.technicalWorksAlertMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(.init(title: self.configuration.tryAgainAlertActionTitle, style: .default, handler: { _ in
            tapTryAgain?()
        }))
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    open func showIosMinimalVersionAlert(tapAppUpdate: (() -> Void)?) {
        let alert = UIAlertController(
            title: self.configuration.iosMinimalVersionAlertTitle,
            message: self.configuration.iosMinimalVersionAlertMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(.init(title: self.configuration.appUpdateAlertActionTitle, style: .default, handler: { _ in
            tapAppUpdate?()
        }))
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    open func showIosActualVersionAlert(tapAppUpdate: (() -> Void)?, tapContinueWithoutUpdating: (() -> Void)?) {
        let alert = UIAlertController(
            title: self.configuration.iosActualVersionAlertTitle,
            message: self.configuration.iosActualVersionAlertMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(.init(title: self.configuration.appUpdateAlertActionTitle, style: .default, handler: { _ in
            tapAppUpdate?()
        }))
        
        alert.addAction(.init(title: self.configuration.continueWithoutUpdatingAlertActionTitle, style: .cancel, handler: { _ in
            tapContinueWithoutUpdating?()
        }))
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    open func openAppInAppStore(completion: ((Bool) -> Void)?) {
        guard let url = self.configuration.urlToAppInAppStore else {
            print("[ACVerifyApplicationAvailability] - [openAppUpdate] - urlToAppInAppStore == nil")
            completion?(false)
            return
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        }
    }
    
}
