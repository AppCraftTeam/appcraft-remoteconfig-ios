//
//  ACVerifyApplicationAvailabilityStyle.swift
//
//
//  Created by Pavel Moslienko on 05.09.2024.
//

import Foundation
import UIKit

/// Struct to define the styles and presentation model for application availability UI components.
public struct ACVerifyApplicationAvailabilityStyle {
    public var presentation: ACPresentationModel
    public var viewStyle: ACStyle<ACMessageViewController>?
    
    public var technicalWorkButtonStyle: ACStyle<UIButton>
    public var actualVersionAproveButtonStyle: ACStyle<UIButton>
    public var actualVersionCancelButtonStyle: ACStyle<UIButton>
    public var minimalVersionButtonStyle: ACStyle<UIButton>
    
    public var viewControllerFactory: ACMessageViewControllerFactory = DefaultMessageViewControllerFactory()
    
    /// Initializes the struct with default styles for buttons and presentation.
    public init(
        presentation: ACPresentationModel = .default,
        viewStyle: ACStyle<ACMessageViewController> = .default,
        technicalWorkButtonStyle: ACStyle<UIButton> = .default,
        minimalVersionButtonStyle: ACStyle<UIButton> = .default,
        actualVersionAproveButtonStyle: ACStyle<UIButton> = .default,
        actualVersionCancelButtonStyle: ACStyle<UIButton> = .cancel
    ) {
        self.viewStyle = viewStyle
        self.presentation = presentation
        self.technicalWorkButtonStyle = technicalWorkButtonStyle
        self.minimalVersionButtonStyle = minimalVersionButtonStyle
        self.actualVersionAproveButtonStyle = actualVersionAproveButtonStyle
        self.actualVersionCancelButtonStyle = actualVersionCancelButtonStyle
    }
}
