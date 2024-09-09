//
//  ACActionButton.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 31.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit

/// A custom button class
class ActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupComponents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupComponents()
    }
    
    /// Initializes the button
    /// - Parameters:
    ///   - title: The title text
    ///   - onAction: Closure to handle tap event
    init(title: String = "", onAction: (() -> Void)? = nil) {
        super.init(frame: .zero)
        self.onAction = onAction
        self.setTitle(title, for: .normal)
        self.setupAction()
    }
    
    /// Convenience initializer
    /// - Parameters:
    ///   - title: The title text
    ///   - type: The type of the button
    ///   - onAction: Closure to handle tap event
    convenience init(
        title: String = "",
        type: UIButton.ButtonType = .system,
        onAction: (() -> Void)? = nil
    ) {
        self.init(type: type)
        self.setTitle(title, for: .normal)
        self.onAction = onAction
        self.setupAction()
    }
    
    /// Closure to be called when the button is tapped
    var onAction: (() -> Void)? {
        didSet { self.setupAction() }
    }
    
    /// Setup for button components
    func setupComponents() {}
    
    /// Updates the button components
    func updateComponents() {}
    
    /// Configures the tap action for the button
    func setupAction() {
        if self.onAction == nil {
            self.removeTarget(self, action: #selector(handleAction), for: .touchUpInside)
        } else {
            self.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        }
    }
    
    /// Handles the button tap
    @objc
    func handleAction() {
        self.onAction?()
    }
}
