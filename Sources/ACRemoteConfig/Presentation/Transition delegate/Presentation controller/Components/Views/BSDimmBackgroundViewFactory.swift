//
//  BSDimmBackgroundViewFactory.swift
//  World Run League
//
//  Created by Damian Bazhenov on 3.5.2022.
//  Copyright © 2022 AppCraft. All rights reserved.
//

import UIKit

/// A default implementation of the `ACCustomPresentationBackgroundFactory` that provides a dimmed background view
struct BSDimmBackgroundViewFactory: ACCustomPresentationBackgroundFactory {
    
    /// The color of the background view
    let backgroundColor: UIColor
    
    /// Initializes the background factory
    /// - Parameter backgroundColor: The color for the dimmed background view
    init(backgroundColor: UIColor = UIColor(white: 0, alpha: 0.3)) {
        self.backgroundColor = backgroundColor
    }
    
    /// Creates and returns a dimmed background view
    func backgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.alpha = 0
        return view
    }
}
