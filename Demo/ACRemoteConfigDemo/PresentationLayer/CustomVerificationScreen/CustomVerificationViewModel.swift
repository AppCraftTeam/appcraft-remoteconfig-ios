//
//  CustomVerificationViewModel.swift
//  ACRemoteConfigDemo
//
//  Created by Pavel Moslienko on 06.09.2024.
//

import Foundation
import UIKit

final class CustomVerificationViewModel {
    
    enum Mode {
        case techWorks, needToUpdate(to: String), possibleToUpdate(to: String)
    }
    
    var mode: CustomVerificationViewModel.Mode
    var onRepeatTapped: (() -> Void)?
    var onContinueTapped: (() -> Void)?
    var onOpenStoreTapped: (() -> Void)?

    init(mode: CustomVerificationViewModel.Mode) {
        self.mode = mode
    }
}
