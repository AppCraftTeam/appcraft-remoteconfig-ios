//
//  ACPresentationControllerSize.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import Foundation

/// Size options for a custom presentation
public enum ACPresentationControllerSize {
    /// A fixed size for the presented view controller
    case fixed(size: CGSize)
    
    /// Percentage screen height where 1 (height equivalent to `containerView`)
    case percent(value: CGFloat)
    
    /// Centers the presented view controller with a specified horizontal inset and height
    case center(horizontalInset: CGFloat, height: CGFloat)
}
