//
//  ACVerifyConfiguration.swift
//
//
//  Created by Pavel Moslienko on 05.09.2024.
//

import Foundation

public struct ACVerifyConfiguration {
    public var urlToAppInAppStore: URL?
    
    public init(urlToAppInAppStore: URL? = nil) {
        self.urlToAppInAppStore = urlToAppInAppStore
    }
}
