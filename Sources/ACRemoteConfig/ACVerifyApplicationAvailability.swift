import Foundation
import UIKit

public struct ACVerifyApplicationAvailabilityStyle {
    public var presentation: PresentationModel
    public var viewStyle: Style<ACMessageViewController>?

    public var technicalWorkButtonStyle: Style<UIButton>
    public var actualVersionAproveButtonStyle: Style<UIButton>
    public var actualVersionCancelButtonStyle: Style<UIButton>

    public var minimalVersionButtonStyle: Style<UIButton>
    
    public var viewControllerFactory: ACMessageViewControllerFactory = DefaultMessageViewControllerFactory()
    
    public init(
        presentation: PresentationModel = .default,
        viewStyle: Style<ACMessageViewController> = .default,
        technicalWorkButtonStyle: Style<UIButton> = .default,
        minimalVersionButtonStyle: Style<UIButton> = .default,
        actualVersionAproveButtonStyle: Style<UIButton> = .default,
        actualVersionCancelButtonStyle: Style<UIButton> = .cancel
    ) {
        self.viewStyle = viewStyle
        self.presentation = presentation
        self.technicalWorkButtonStyle = technicalWorkButtonStyle
        self.minimalVersionButtonStyle = minimalVersionButtonStyle
        self.actualVersionAproveButtonStyle = actualVersionAproveButtonStyle
        self.actualVersionCancelButtonStyle = actualVersionCancelButtonStyle
    }
}

public struct PresentationModel {
    public var cornerRadius: CGFloat
    public var animationDuration: TimeInterval
    public var size: ACPresentationControllerSize
    public var backgroundFactory: ACCustomPresentationBackgroundFactory
    
    public static var `default`: PresentationModel {
        .init(
            cornerRadius: 16,
            animationDuration: 0.25,
            size: .percent(value: 0.5),
            backgroundFactory: BSDimmBackgroundViewFactory()
        )
    }
    
    public func makeDelegate() -> ACTransitionDelegate {
        ACTransitionDelegate(
            cornerRadius: cornerRadius,
            animationDuration: animationDuration,
            size: size,
            backgroundFactory: backgroundFactory
        )
    }
}

open class ACVerifyApplicationAvailability {
    
    public typealias VerifyCompletion = (Bool) -> Void
    
    // MARK: - Props
    open weak var viewController: UIViewController?
    
    open var style = ACVerifyApplicationAvailabilityStyle()
    
    open var configuration: Configuration = .default()
    
    // MARK: - Methods

    open func verify(fromModel model: ACRemoteConfig?, completion: VerifyCompletion?, didTryAgain: (() -> Void)?) {
        guard let model = model else {
            completion?(true)
            return
        }

        guard !model.technicalWorks else {
            self.showTechnicalWorksAlert {
                didTryAgain?()
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

        if appVersionFull.compare(model.iosMinimalVersion, options: .numeric) == .orderedAscending {

            self.showIosMinimalVersionAlert { [weak self] in
                self?.openAppInAppStore { _ in
                    completion?(false)
                }
            }

        } else if appVersionFull.compare(model.iosActualVersion, options: .numeric) == .orderedAscending {

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
    
    public init(viewController: UIViewController? = nil, style: ACVerifyApplicationAvailabilityStyle = ACVerifyApplicationAvailabilityStyle(), configuration: Configuration) {
        self.viewController = viewController
        self.style = style
        self.configuration = configuration
    }
}

// MARK: - Models
public extension ACVerifyApplicationAvailability {
   
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
    
    public func showTechnicalWorksAlert(tapTryAgain: (() -> Void)?) {
        let vc = style.viewControllerFactory.make()
        vc.titleText = configuration.technicalWorksAlertTitle ?? ""
        vc.subtitleText = configuration.technicalWorksAlertMessage ?? ""
        
        vc.addActions([
            .init(
                text: configuration.tryAgainAlertActionTitle,
                style: style.technicalWorkButtonStyle,
                action: {
                    tapTryAgain?()
                }
            )
        ])
        self.showSheetViewController(vc)
    }
    
    public func showIosMinimalVersionAlert(tapAppUpdate: (() -> Void)?) {
        let viewController = style.viewControllerFactory.make()
        viewController.titleText = configuration.iosMinimalVersionAlertTitle ?? ""
        viewController.subtitleText = configuration.iosMinimalVersionAlertMessage ?? ""
        
        viewController.addActions([
            .init(
                text: self.configuration.appUpdateAlertActionTitle,
                style: self.style.minimalVersionButtonStyle,
                action: { tapAppUpdate?() }
            )
        ])
        
        self.showSheetViewController(viewController)
    }
    
    public func showIosActualVersionAlert(tapAppUpdate: (() -> Void)?, tapContinueWithoutUpdating: (() -> Void)?) {
        let viewController = style.viewControllerFactory.make()
        viewController.titleText = configuration.iosActualVersionAlertTitle ?? ""
        viewController.subtitleText = configuration.iosActualVersionAlertMessage ?? ""
        
        viewController.addActions([
            .init(
                text: self.configuration.appUpdateAlertActionTitle,
                style: self.style.actualVersionAproveButtonStyle,
                action: {
                    tapAppUpdate?()
                }
            ),
            .init(
                text: self.configuration.continueWithoutUpdatingAlertActionTitle,
                style: self.style.actualVersionCancelButtonStyle,
                action: { [weak viewController] in
                    viewController?.dismiss(animated: true)
                    tapContinueWithoutUpdating?()
                }
            )
        ])
        self.showSheetViewController(viewController)
    }
    
    public func openAppInAppStore(completion: ((Bool) -> Void)?) {
        guard let url = self.configuration.urlToAppInAppStore else {
            print("[ACVerifyApplicationAvailability] - [openAppUpdate] - urlToAppInAppStore == nil")
            completion?(false)
            return
        }

        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        }
    }
    
    func showSheetViewController(_ viewController: UIViewController) {
        if self.viewController?.topMostViewController() is ACMessageViewController {
            return
        }
        
        let transitionDelegate = ACTransitionDelegate(
            cornerRadius: style.presentation.cornerRadius,
            animationDuration: style.presentation.animationDuration,
            size: style.presentation.size,
            backgroundFactory: style.presentation.backgroundFactory
        )
        viewController.transitioningDelegate = transitionDelegate
        viewController.modalPresentationStyle = .custom
        self.viewController?.present(viewController, animated: true, completion: nil)
    }
}
