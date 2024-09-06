//
//  ACVerifyUIFactory.swift
//  
//
//  Created by Pavel Moslienko on 05.09.2024.
//

import Foundation
import UIKit

public protocol ACVerifyUIFactory {
    var style: ACVerifyApplicationAvailabilityStyle { get set }

    func makeTechnicalWorksAlert(tapTryAgain: (() -> Void)?) -> UIViewController
    func makeIosMinimalVersionAlert(tapOpenStore: (() -> Void)?) -> UIViewController
    func makeIosActualVersionAlert(tapOpenStore: (() -> Void)?, tapContinueWithoutUpdating: (() -> Void)?) -> UIViewController
    
    func presentViewController(_ viewController: UIViewController, from parentViewController: UIViewController?)
}
