//
//  ACVerifyUIFactory.swift
//  
//
//  Created by Pavel Moslienko on 05.09.2024.
//

import Foundation
import UIKit

public protocol ACVerifyUIFactory {
    func makeTechnicalWorksAlert(tapTryAgain: (() -> Void)?) -> UIViewController
    func makeIosMinimalVersionAlert(tapOpenStore: (() -> Void)?) -> UIViewController
    func makeIosActualVersionAlert(tapOpenStore: (() -> Void)?, tapContinueWithoutUpdating: (() -> Void)?) -> UIViewController
}
