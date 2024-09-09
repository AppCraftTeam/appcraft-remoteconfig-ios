//
//  VerifySource.swift
//  ACRemoteConfigDemo
//
//  Created by Pavel Moslienko on 06.09.2024.
//

import Foundation

enum VerifySource: CaseIterable {
    case firebase, localTechWorks, localRequiredAppUpdate, localNotRequiredAppUpdate, localAllCorrect
    
    var title: String {
        switch self {
        case .firebase:
            return "From Firebase"
        case .localTechWorks:
            return "Local model with tech works"
        case .localRequiredAppUpdate:
            return "Local model with required update"
        case .localNotRequiredAppUpdate:
            return "Local model with not required update"
        case .localAllCorrect:
            return "Local model with no reason to show blocked window"
        }
    }
}
