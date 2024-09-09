//
//  MainViewModel.swift
//  ACRemoteConfigDemo
//
//  Created by Pavel Moslienko on 06.09.2024.
//

import ACRemoteConfig
import Foundation
import UIKit

final class MainViewModel {
    
    let options = VerifyOptions.allCases
    let sources = VerifySource.allCases
    var currentOption: VerifyOptions
    var currentSource: VerifySource
    var onReadyVerifiedConfig: ((_: ACRemoteConfig) -> Void)?
    
    init() {
        currentOption = .defaultScreen
        currentSource = .firebase
    }
    
    func handleOption(_ option: VerifyOptions) {
        self.currentOption = option
        self.checkApplicationAvailability()
    }
    
    func verifyConfig(on parentScreen: UIViewController, configModel: ACRemoteConfig) {
        print("iOS Actual Version: \(configModel.iosActualVersion)")
        print("iOS Minimal Version: \(configModel.iosMinimalVersion)")
        print("Technical Works: \(configModel.technicalWorks)")
        
        var verifyApplicationAvailability: ACVerifyApplicationAvailability {
            switch self.currentOption {
            case .defaultScreen:
                let result = ACVerifyApplicationAvailability(configuration: ACVerifyConfiguration(urlToAppInAppStore: nil))
                result.viewController = parentScreen
                result.customUIFactory.style.presentation.size = .percent(value: 1.0)
                return result
            case .defaultScreenWithOptions:
                let result = ACVerifyApplicationAvailability(configuration: ACVerifyConfiguration(urlToAppInAppStore: nil))
                result.viewController = parentScreen
                result.customUIFactory.style.presentation.size = .percent(value: 0.5)
                result.customUIFactory.style.technicalWorkButtonStyle = ACStyle<UIButton>(make: { button in
                    button.backgroundColor = .systemBlue
                    button.setTitleColor(.white, for: [])
                    button.layer.cornerRadius = 10
                })

                return result
            case .customScreen:
                let result = ACVerifyApplicationAvailability(configuration: ACVerifyConfiguration(urlToAppInAppStore: nil))
                result.viewController = parentScreen
                result.customUIFactory = CustomVerifyUiFactory(
                    minAppVersion: configModel.iosMinimalVersion,
                    actualAppVersion: configModel.iosActualVersion
                )
                return result
            case .customHandler:
                let result = CustomConfigHandler(configuration: ACVerifyConfiguration(urlToAppInAppStore: nil))
                result.viewController = parentScreen
                return result
            }
        }
        
        verifyApplicationAvailability.verify(fromModel: configModel) { verifed in
            guard verifed else { return }
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "App verifed! Allow show next screen", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default) )
                parentScreen.present(alert, animated: true)
            }
        } didTryAgain: {
            self.checkApplicationAvailability()
        }
    }
}

private extension MainViewModel {
    
    func startObserver() {
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
        fetchingConfig { config in
            guard let config = config else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.onReadyVerifiedConfig?(config)
            }
        }
    }
    
    func fetchingConfig(finished: @escaping (_ config: ACRemoteConfig?) -> Void) {
        switch self.currentSource {
        case .firebase:
            let handler = FirebaseRemoteConfigService()
            handler.fetchOnlyInRelease = false
            fetchAndHandeActialConfig()
            
            func fetchAndHandeActialConfig() {
                handler.fetch { error in
                    finished(handler.getRemoteConfigModel())
                }
            }
        case .localTechWorks:
            let configModel = RemoteConfigModel(
                iosActualVersion: "",
                iosMinimalVersion: "",
                technicalWorks: true
            )
            finished(configModel)
        case .localRequiredAppUpdate:
            let configModel = RemoteConfigModel(
                iosActualVersion: "",
                iosMinimalVersion: "2.0.0",
                technicalWorks: false
            )
            finished(configModel)
        case .localNotRequiredAppUpdate:
            let configModel = RemoteConfigModel(
                iosActualVersion: "2.0.0",
                iosMinimalVersion: "",
                technicalWorks: false
            )
            finished(configModel)
        case .localAllCorrect:
            let configModel = RemoteConfigModel(
                iosActualVersion: "",
                iosMinimalVersion: "",
                technicalWorks: false
            )
            finished(configModel)
        }
    }
}
