//
//  ACVerifyHandler.swift
//
//
//  Created by Pavel Moslienko on 05.09.2024.
//

import Foundation

/// Protocol for handling the verification of the apps configuration and availability
public protocol ACVerifyHandler {
    
    /// Verifies the apps availability
    /// - Parameters:
    ///   - model: Кemote configuration model
    ///   - completion: Сlosure that returns a boolean indicating success or failure
    ///   - didTryAgain: Сlosure that gets called when the user tapped to try the verification again
    func verify(fromModel model: ACRemoteConfig?, completion: ((Bool) -> Void)?, didTryAgain: (() -> Void)?)
}
