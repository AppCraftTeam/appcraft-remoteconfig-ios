//
//  ACStyle.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit

/// Used for styling UI components
public struct ACStyle<T> {
    let make: (T) -> Void
    
    /// Initializes the `ACStyle
    public init(make: @escaping (T) -> Void) {
        self.make = make
    }
}

// MARK: ACMessageViewController
extension ACStyle where T == ACMessageViewController {
    /// Default style for `ACMessageViewController`
    public static var `default`: ACStyle {
        .init { _ in }
    }
}

// MARK: UIButton
extension ACStyle where T == UIButton {
    /// Default style for default `UIButton`
    public static var `default`: ACStyle {
        .init { button in
            let color: UIColor = if #available(iOS 13, *) { .label } else { .black }
            button.setTitleColor(color, for: .normal)
        }
    }
    
    /// Style for a cancel `UIButton`
    public static var cancel: ACStyle {
        .init { button in
            button.setTitleColor(.systemRed, for: .normal)
        }
    }
}
