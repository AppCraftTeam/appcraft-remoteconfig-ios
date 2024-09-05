//
//  MainViewController.swift
//  ACRemoteConfigDemo
//
//  Created by Дмитрий Поляков on 24.11.2021.
//

import UIKit
import ACRemoteConfig

class MainViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var verifyApplicationAvailability: ACVerifyApplicationAvailability = {
        let result = ACVerifyApplicationAvailability(configuration: .default())
        result.viewController = self
        result.style.presentation.size = .percent(value: 0.5)
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleApplicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        checkApplicationAvailability()
    }
    
    @objc
    func handleApplicationDidBecomeActive() {
        self.checkApplicationAvailability()
    }
    
    func checkApplicationAvailability() {
        let handler = FirebaseRemoteConfigService()
        handler.fetchOnlyInRelease = false
        
        fetchAndHandeActialConfig()
        
        func fetchAndHandeActialConfig() {
            handler.fetch { error in
                if let error = error {
                    print("Failed to fetch remote config: \(error)")
                } else {
                    if let configModel = handler.getRemoteConfigModel() {
                        print("iOS Actual Version: \(configModel.iosActualVersion)")
                        print("iOS Minimal Version: \(configModel.iosMinimalVersion)")
                        print("Technical Works: \(configModel.technicalWorks)")
                        
                        DispatchQueue.main.async {
                            self.verifyApplicationAvailability.verify(fromModel: configModel) { verifed in
                                guard verifed else { return }
                                DispatchQueue.main.async {
                                    self.present(
                                        UIAlertController(title: "App verifed! Show next screen", message: nil, preferredStyle: .alert),
                                        animated: true,
                                        completion: nil
                                    )
                                }
                            } didTryAgain: {
                                fetchAndHandeActialConfig()
                            }
                        }
                    } else {
                        print("Failed to map remote config data")
                    }
                }
            }
        }
    }
}
