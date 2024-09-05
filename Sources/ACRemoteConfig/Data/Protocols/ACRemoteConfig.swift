//
//  File.swift
//
//
//  Created by Pavel Moslienko on 05.09.2024.
//

import Foundation

public protocol ACRemoteConfig {
    var iosActualVersion: String { get }
    var iosMinimalVersion: String { get }
    var technicalWorks: Bool { get }
}
