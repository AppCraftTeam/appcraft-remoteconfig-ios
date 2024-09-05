import Foundation
import ACRemoteConfig
import UIKit
import FirebaseRemoteConfig

class FirebaseRemoteConfigService: NSObject {
    
    typealias FetchCompletion = (Error?) -> Void
    
    // MARK: - Properties
    private let remoteConfig: RemoteConfig
    var fetchOnlyInRelease: Bool
    
    // MARK: - Initializer
    override init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        self.fetchOnlyInRelease = true
        
        super.init()
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 10
        self.remoteConfig.configSettings = settings
    }
    
    // MARK: - Public Methods
    func isFetchAvailable() -> Bool {
        guard fetchOnlyInRelease else { return true }
        
#if DEBUG
        return false
#else
        return Bundle.main.appStoreReceiptURL?.lastPathComponent != "sandboxReceipt"
#endif
    }
    
    func fetch(completion: FetchCompletion? = nil) {
        guard isFetchAvailable() else {
            completion?(nil)
            return
        }
        
        remoteConfig.fetch { [weak self] status, error in
            guard error == nil, status == .success else {
                completion?(error)
                return
            }
            
            self?.remoteConfig.activate { _, error in
                completion?(error)
            }
        }
    }
    
    func getRemoteConfigModel() -> RemoteConfigModel? {
        return RemoteConfigModel(remoteConfig: remoteConfig)
    }
}
