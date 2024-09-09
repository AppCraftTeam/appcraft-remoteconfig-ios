//
//  FileACRemoteConfigswift
//
//
//  Created by Pavel Moslienko on 05.09.2024.
//

/// Protocol representing the remote configuration model
public protocol ACRemoteConfig {
    /// The actual version of the app
    var iosActualVersion: String { get }
    
    /// The minimal supported version of the app
    var iosMinimalVersion: String { get }
    
    /// A flag indicating whether technical works are currently in progress
    var technicalWorks: Bool { get }
}
