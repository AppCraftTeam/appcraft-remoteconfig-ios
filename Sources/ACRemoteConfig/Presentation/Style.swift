//
//  Style.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit

public struct Style<T> {
    let make: (T) -> Void
}

extension Style where T == ACMessageViewController {
    public static var `default`: Style {
        .init { _ in }
    }
}

extension Style where T == UIButton {
    public static var `default`: Style {
        .init { button in
            button.setTitleColor(.label, for: .normal)
        }
    }
    
    public static var cancel: Style {
        .init { button in
            button.setTitleColor(.systemRed, for: .normal)
        }
    }
}
