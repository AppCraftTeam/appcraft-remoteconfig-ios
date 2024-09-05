//
//  ACVerifyApplicationAvailabilityStyle.swift
//
//
//  Created by Pavel Moslienko on 05.09.2024.
//

import Foundation
import UIKit

public struct ACVerifyApplicationAvailabilityStyle {
    public var presentation: PresentationModel
    public var viewStyle: Style<ACMessageViewController>?

    public var technicalWorkButtonStyle: Style<UIButton>
    public var actualVersionAproveButtonStyle: Style<UIButton>
    public var actualVersionCancelButtonStyle: Style<UIButton>

    public var minimalVersionButtonStyle: Style<UIButton>
    
    public var viewControllerFactory: ACMessageViewControllerFactory = DefaultMessageViewControllerFactory()
    
    public init(
        presentation: PresentationModel = .default,
        viewStyle: Style<ACMessageViewController> = .default,
        technicalWorkButtonStyle: Style<UIButton> = .default,
        minimalVersionButtonStyle: Style<UIButton> = .default,
        actualVersionAproveButtonStyle: Style<UIButton> = .default,
        actualVersionCancelButtonStyle: Style<UIButton> = .cancel
    ) {
        self.viewStyle = viewStyle
        self.presentation = presentation
        self.technicalWorkButtonStyle = technicalWorkButtonStyle
        self.minimalVersionButtonStyle = minimalVersionButtonStyle
        self.actualVersionAproveButtonStyle = actualVersionAproveButtonStyle
        self.actualVersionCancelButtonStyle = actualVersionCancelButtonStyle
    }
}

public struct PresentationModel {
    public var cornerRadius: CGFloat
    public var animationDuration: TimeInterval
    public var size: ACPresentationControllerSize
    public var backgroundFactory: ACCustomPresentationBackgroundFactory
    
    public static var `default`: PresentationModel {
        .init(
            cornerRadius: 16,
            animationDuration: 0.25,
            size: .percent(value: 0.5),
            backgroundFactory: BSDimmBackgroundViewFactory()
        )
    }
    
    public func makeDelegate() -> ACTransitionDelegate {
        ACTransitionDelegate(
            cornerRadius: cornerRadius,
            animationDuration: animationDuration,
            size: size,
            backgroundFactory: backgroundFactory
        )
    }
}
