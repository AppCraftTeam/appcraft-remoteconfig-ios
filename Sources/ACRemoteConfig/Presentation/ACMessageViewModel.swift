//
//  ACMessageViewModel.swift
//
//
//  Created by Pavel Moslienko on 11.09.2024.
//

import Foundation

public class ACMessageViewModel {
    
    public var actions: [ACMessageViewController.ActionModel]
    public var localeConfiguration: LocaleConfiguration
    
    public init(
        actions: [ACMessageViewController.ActionModel],
        localeConfiguration: ACMessageViewModel.LocaleConfiguration
    ) {
        self.actions = actions
        self.localeConfiguration = localeConfiguration
    }
    
    /// The default configuration for the UI related to app availability and verification.
    public struct LocaleConfiguration {
        
        /// Title for the technical works alert
        public var technicalWorksAlertTitle: String?
        
        /// Message for the technical works alert
        public var technicalWorksAlertMessage: String?
        
        /// Title for the minimal iOS version alert
        public var iosMinimalVersionAlertTitle: String?
        
        /// Message for the minimal iOS version alert
        public var iosMinimalVersionAlertMessage: String?
        
        /// Title for the iOS actual version alert
        public var iosActualVersionAlertTitle: String?
        
        /// Message for the iOS actual version alert
        public var iosActualVersionAlertMessage: String?
        
        /// Title for the "try again" button
        public var tryAgainAlertActionTitle: String
        
        /// Title for the "continue without updating" button
        public var continueWithoutUpdatingAlertActionTitle: String
        
        ///Title for the "update app" button
        public var appUpdateAlertActionTitle: String
        
        /// Returns the default UI configuration
        public static func `default`() -> LocaleConfiguration {
            func localized(_ key: String) -> String {
                NSLocalizedString(key, bundle: .module, comment: "")
            }
            return LocaleConfiguration(
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
        
        /// Initializes the default UI configuration
        /// - Parameters:
        ///   - technicalWorksAlertTitle: Title for the technical works alert
        ///   - technicalWorksAlertMessage: Message for the technical works alert
        ///   - iosMinimalVersionAlertTitle: Title for the minimal iOS version alert
        ///   - iosMinimalVersionAlertMessage: Message for the minimal iOS version alert
        ///   - iosActualVersionAlertTitle: Title for the iOS actual version alert
        ///   - iosActualVersionAlertMessage: Message for the iOS actual version alert
        ///   - tryAgainAlertActionTitle: Title for the "try again" button
        ///   - continueWithoutUpdatingAlertActionTitle: Title for the "continue without updating" button
        ///   - appUpdateAlertActionTitle: Title for the "update app" button
        public init(
            technicalWorksAlertTitle: String? = nil,
            technicalWorksAlertMessage: String? = nil,
            iosMinimalVersionAlertTitle: String? = nil,
            iosMinimalVersionAlertMessage: String? = nil,
            iosActualVersionAlertTitle: String? = nil,
            iosActualVersionAlertMessage: String? = nil,
            tryAgainAlertActionTitle: String,
            continueWithoutUpdatingAlertActionTitle: String,
            appUpdateAlertActionTitle: String
        ) {
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
}
