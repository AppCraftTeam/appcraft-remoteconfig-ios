import Foundation
import FirebaseRemoteConfig
#warning("tosdo")
public protocol ACRemoteConfigModelProtocol: Codable {
    init?(remoteConfig: RemoteConfig)
}
