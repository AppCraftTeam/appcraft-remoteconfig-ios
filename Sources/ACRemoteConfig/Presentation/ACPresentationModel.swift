import UIKit

/// Struct representing the visual configuration for the presentation of a view controller
public struct ACPresentationModel {
    public var cornerRadius: CGFloat
    public var animationDuration: TimeInterval
    public var size: ACPresentationControllerSize
    public var backgroundFactory: ACCustomPresentationBackgroundFactory
    
    /// Default configuration for the presentation
    public static var `default`: ACPresentationModel {
        .init(
            cornerRadius: 16,
            animationDuration: 0.25,
            size: .percent(value: 0.5),
            backgroundFactory: BSDimmBackgroundViewFactory()
        )
    }
    
    /// Creates and returns a transition delegate based on the current configuration
    public func makeDelegate() -> ACTransitionDelegate {
        ACTransitionDelegate(
            cornerRadius: cornerRadius,
            animationDuration: animationDuration,
            size: size,
            backgroundFactory: backgroundFactory
        )
    }
}
