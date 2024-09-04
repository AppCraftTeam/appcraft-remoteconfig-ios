import Foundation
import ACRemoteConfig
import UIKit
import FirebaseRemoteConfig

 class ACRemoteConfigHandler: NSObject {
    
     typealias FetchCompletion = (Error?) -> Void
    
    // MARK: - Init
     override init() {
        self.remoteConfig = .remoteConfig()
        
        super.init()
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 10
        self.remoteConfig.configSettings = settings
    }
    
    // MARK: - Props
     var remoteConfig: RemoteConfig
     var fetchOnlyRelease: Bool = true
    
    // MARK: - Methods
     func fetchAvalible() -> Bool {
        guard self.fetchOnlyRelease else { return true }
        
        #if DEBUG
        return false
        #else
        if Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" {
            return false
        } else {
            return true
        }
        #endif
    }
    
     func fetch(completion: FetchCompletion? = nil) {
        guard self.fetchAvalible() else {
            completion?(nil)
            return
        }
        
        self.remoteConfig.fetch { [weak self] status, error in
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
        return RemoteConfigModel(remoteConfig: self.remoteConfig)
    }
}
