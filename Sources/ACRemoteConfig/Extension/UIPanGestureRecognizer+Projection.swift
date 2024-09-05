//
//  UIPanGestureRecognizer+projectedLocation.swift
//  ACRemoteConfig
//
//  Created by Damian Bazhenov on 30.05.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit

extension UIPanGestureRecognizer {
    
    func projectedLocation(decelerationRate: UIScrollView.DecelerationRate) -> CGPoint {
        let velocityOffset = velocity(in: view).projectedOffset(decelerationRate: decelerationRate)
        let projectedLocation = location(in: view) + velocityOffset
        return projectedLocation
    }
    
    func isProjectedToDownHalf(maxTranslation: CGFloat) -> Bool {
        let endLocation = projectedLocation(decelerationRate: .normal)
        return endLocation.y > maxTranslation / 2
    }
}
