//
//  ACVerifyHandler.swift
//
//
//  Created by Pavel Moslienko on 05.09.2024.
//

import Foundation

public protocol ACVerifyHandler {
    func verify(fromModel model: ACRemoteConfig?, completion: ((Bool) -> Void)?, didTryAgain: (() -> Void)?)
}
