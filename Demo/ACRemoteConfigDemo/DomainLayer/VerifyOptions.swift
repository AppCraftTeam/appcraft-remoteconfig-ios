//
//  VerifyOptions.swift
//  ACRemoteConfigDemo
//
//  Created by Pavel Moslienko on 06.09.2024.
//

import Foundation

enum VerifyOptions: CaseIterable {
    case defaultScreen, defaultScreenWithOptions, customScreen, customHandler
    
    var title: String {
        switch self {
        case .defaultScreen:
            return "Default Screen"
        case .defaultScreenWithOptions:
            return "Default Screen with options"
        case .customScreen:
            return "Custom Screen"
        case .customHandler:
            return "Custom Handler"
        }
    }
    
    var subtitle: String {
        switch self {
        case .defaultScreen:
            return "Standard screen without custom settings"
        case .defaultScreenWithOptions:
            return "Standard screen with custom settings"
        case .customScreen:
            return "Custom screen using a standard handler"
        case .customHandler:
            return "Custom screen using a custom handler"
        }
    }
}

