//
//  ACCustomPresentationBackgroundFactory.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit

/// A protocol for creating a custom background view
public protocol ACCustomPresentationBackgroundFactory {
    
    /// Creates and returns the background view
    func backgroundView() -> UIView
}
