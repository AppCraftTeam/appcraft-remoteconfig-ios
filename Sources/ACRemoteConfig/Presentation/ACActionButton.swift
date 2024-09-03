//
//  ACActionButton.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 31.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupComponents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupComponents()
    }
    
    init(title: String = "", onAction: (() -> Void)? = nil) {
        super.init(frame: .zero)
        self.onAction = onAction
        self.setTitle(title, for: .normal)
        self.setupAction()
    }
    
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
    
    var onAction: (() -> Void)? {
        didSet { self.setupAction() }
    }
    
    func setupComponents() {}
    
    func updateComponents() {}
        
    func setupAction() {
        if self.onAction == nil {
            self.removeTarget(self, action: #selector(handleAction), for: .touchUpInside)
        } else {
            self.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        }
    }
    
    @objc
    func handleAction() {
        self.onAction?()
    }
}
