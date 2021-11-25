//
//  ViewController.swift
//  ACRemoteConfigDemo
//
//  Created by Дмитрий Поляков on 24.11.2021.
//

import UIKit
import ACRemoteConfig

class ViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var verifyApplicationAvailability: ACVerifyApplicationAvailability = {
        let result = ACVerifyApplicationAvailability()
        result.viewController = self
        
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleApplicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc
    func handleApplicationDidBecomeActive() {
        self.checkApplicationAvailability()
    }
    
    func checkApplicationAvailability() {
//        self.verifyApplicationAvailability.fetchAndVerify { verifed in
//            guard verifed else { return }
//
//            self.present(UIAlertController(title: "App verifed!", message: nil, preferredStyle: .alert), animated: true, completion: nil)
//        }
        
        self.verifyApplicationAvailability.fetchOnlyRelease = false
        self.verifyApplicationAvailability.verify(fromModel: .init(iosActualVersion: "1.0.0", iosMinimalVersion: "2.0.0", technicalWorks: true)) { _ in
            //
        }
    }


}

