//
//  ACPresentationControllerSize.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//


import Foundation

public enum ACPresentationControllerSize {
    case fixed(size: CGSize)
    /// Percentage screen height where 1 (height equivalent to `containerView`)
    case percent(value: CGFloat)
    case center(horizontalInset: CGFloat, height: CGFloat)
}
