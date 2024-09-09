//
//  ACVerifyConfiguration.swift
//
//
//  Created by Pavel Moslienko on 05.09.2024.
//

import Foundation

/// Configuration for verifying the apps availability
public struct ACVerifyConfiguration {
    
    /// The URL to the app in App Store.
    public var urlToAppInAppStore: URL?
    
    /// Initializes the verification configuration
    /// - Parameter urlToAppInAppStore: The URL to the app in App Store
    public init(urlToAppInAppStore: URL? = nil) {
        self.urlToAppInAppStore = urlToAppInAppStore
    }
}
