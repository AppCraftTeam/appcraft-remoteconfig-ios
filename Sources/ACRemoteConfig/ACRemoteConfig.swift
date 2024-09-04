//
//  ACRemoteConfig.swift
//
//
//  Created by Pavel Moslienko on 04.09.2024.
//

import Foundation

open class ACRemoteConfig {
    public let iosActualVersion: String
    public let iosMinimalVersion: String
    public let technicalWorks: Bool

    public init(iosActualVersion: String, iosMinimalVersion: String, technicalWorks: Bool) {
        self.iosActualVersion = iosActualVersion
        self.iosMinimalVersion = iosMinimalVersion
        self.technicalWorks = technicalWorks
    }
}
