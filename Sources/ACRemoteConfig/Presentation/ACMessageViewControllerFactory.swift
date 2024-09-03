//
//  ACMessageViewControllerFactory.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import Foundation

public protocol ACMessageViewControllerFactory {
    func make() -> ACMessageViewControllerProtocol
}

public struct DefaultMessageViewControllerFactory: ACMessageViewControllerFactory {
    public func make() -> any ACMessageViewControllerProtocol {
        ACMessageViewController()
    }
}
