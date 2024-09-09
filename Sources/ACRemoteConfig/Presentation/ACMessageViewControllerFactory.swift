//
//  ACMessageViewControllerFactory.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import Foundation

/// Protocol for a factory that creates instances of `ACMessageViewControllerProtocol`
public protocol ACMessageViewControllerFactory {
    /// Method to create an instance of `ACMessageViewControllerProtocol`
    func make() -> ACMessageViewControllerProtocol
}

// Default implementation of the `ACMessageViewControllerFactory`
public struct DefaultMessageViewControllerFactory: ACMessageViewControllerFactory {
    public func make() -> any ACMessageViewControllerProtocol {
        ACMessageViewController()
    }
}
