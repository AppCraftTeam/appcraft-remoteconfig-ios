import Foundation

public struct ACDefaultUIConfiguration {
    public var technicalWorksAlertTitle: String?
    public var technicalWorksAlertMessage: String?
    public var iosMinimalVersionAlertTitle: String?
    public var iosMinimalVersionAlertMessage: String?
    public var iosActualVersionAlertTitle: String?
    public var iosActualVersionAlertMessage: String?
    public var tryAgainAlertActionTitle: String
    public var continueWithoutUpdatingAlertActionTitle: String
    public var appUpdateAlertActionTitle: String
    
    public static func `default`() -> ACDefaultUIConfiguration {
        func localized(_ key: String) -> String {
            NSLocalizedString(key, bundle: .module, comment: "")
        }
        return ACDefaultUIConfiguration(
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
    
    public init(technicalWorksAlertTitle: String? = nil, technicalWorksAlertMessage: String? = nil, iosMinimalVersionAlertTitle: String? = nil, iosMinimalVersionAlertMessage: String? = nil, iosActualVersionAlertTitle: String? = nil, iosActualVersionAlertMessage: String? = nil, tryAgainAlertActionTitle: String, continueWithoutUpdatingAlertActionTitle: String, appUpdateAlertActionTitle: String) {
        self.technicalWorksAlertTitle = technicalWorksAlertTitle
        self.technicalWorksAlertMessage = technicalWorksAlertMessage
        self.iosMinimalVersionAlertTitle = iosMinimalVersionAlertTitle
        self.iosMinimalVersionAlertMessage = iosMinimalVersionAlertMessage
        self.iosActualVersionAlertTitle = iosActualVersionAlertTitle
        self.iosActualVersionAlertMessage = iosActualVersionAlertMessage
        self.tryAgainAlertActionTitle = tryAgainAlertActionTitle
        self.continueWithoutUpdatingAlertActionTitle = continueWithoutUpdatingAlertActionTitle
        self.appUpdateAlertActionTitle = appUpdateAlertActionTitle
    }
}
