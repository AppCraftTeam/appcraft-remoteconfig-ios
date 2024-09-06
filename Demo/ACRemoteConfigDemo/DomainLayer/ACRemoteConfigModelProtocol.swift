import Foundation
import FirebaseRemoteConfig

public protocol ACRemoteConfigModelProtocol: Codable {
    init?(remoteConfig: RemoteConfig)
}
