//
//  RemoteConfigModel.swift
//  ACRemoteConfigDemo
//
//  Created by Pavel Moslienko on 04.09.2024.
//

import ACRemoteConfig
import FirebaseRemoteConfig
import Foundation

struct RemoteConfigModel: ACRemoteConfigModelProtocol {
    public let iosActualVersion: String
    public let iosMinimalVersion: String
    public let technicalWorks: Bool
    
    public enum CodingKeys: String, CodingKey {
        case iosActualVersion = "iosActualVersion"
        case iosMinimalVersion = "iosMinimalVersion"
        case technicalWorks = "technicalWorks"
    }
    
    public init?(remoteConfig: RemoteConfig) {
        self.iosActualVersion = remoteConfig[CodingKeys.iosActualVersion.rawValue].stringValue
        self.iosMinimalVersion = remoteConfig[CodingKeys.iosMinimalVersion.rawValue].stringValue
        self.technicalWorks = remoteConfig[CodingKeys.technicalWorks.rawValue].boolValue
    }
    
    public init(
        iosActualVersion: String,
        iosMinimalVersion: String,
        technicalWorks: Bool
    ) {
        self.iosActualVersion = iosActualVersion
        self.iosMinimalVersion = iosMinimalVersion
        self.technicalWorks = technicalWorks
    }
}

extension ACRemoteConfig {
    
    static func create(from configModel: RemoteConfigModel) -> ACRemoteConfig {
        ACRemoteConfig(
            iosActualVersion: configModel.iosActualVersion,
            iosMinimalVersion: configModel.iosActualVersion,
            technicalWorks: configModel.technicalWorks
        )
    }
}
