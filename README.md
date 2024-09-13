# ACRemoteConfig

[![Swift](https://img.shields.io/badge/Swift-5-orange?style=flat-square)](https://img.shields.io/badge/Swift-5-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
[![version](https://img.shields.io/badge/version-1.0.2-white.svg)](https://semver.org)

The library is used for checking the availability of an application using a configuration file that specifies server availability, current and minimum version of the application in App Store. Using these parameters either opens a block screen, which does not allow the user to continue working in the application until the required action (e.g. update to the latest version) is performed, or allows the user to continue working in the application.

## Requirements
- Xcode 13 and later
- iOS 11 and later
- Swift 5.0 and later

## Overview
* [Demo](#demo)
* [Install](#install)
* [Usage](#Usage)
	* [Config file](#config-file)
	* [Verify config](#verify-config)
	* [Custom screen](#custom-screen)
	* [Custom handler](#custom-handler)
	* [Localization](#localization)
* [License](#License)

## Demo
All these examples, as well as the integration of the `ACRemoteConfig` module into the application, can be seen in action in the [Demo project](/Demo).

## Install
To install this Swift package into your project, follow these steps:

1. Open your Xcode project.
2. Go to "File" > "Swift Packages" > "Add Package Dependency".
3. In the "Choose Package Repository" dialog, enter `https://github.com/AppCraftTeam/appcraft-remoteconfig-ios.git`.
4. Click "Next" and select the version you want to use.
5. Choose the target where you want to add the package and click "Finish".

Xcode will then resolve the package and add it to your project. You can now import and use the package in your code.

## Usage
### Config file

Retrieve or create the config any way you want, if it is hosted via Firebase Remote Config you can use the following [class](/Demo/ACRemoteConfigDemo/ServiceLayer/FirebaseRemoteConfigService.swift) from [Demo](#demo). Your  config file must conform to the `ACRemoteConfig` protocol:

```swift
public protocol ACRemoteConfig {
  var iosActualVersion: String { get }
  var iosMinimalVersion: String { get }
  var technicalWorks: Bool { get }
}
```

### Verify config

To handle the config you need to create an object of the class `ACVerifyApplicationAvailability`:

```swift
init(
  parentViewController: UIViewController?,
  urlToAppInAppStore: URL?
)
```

And pass the config model there:

```swift
let verifyApplicationAvailability = ACVerifyApplicationAvailability(parentViewController: parentScreen)

verifyApplicationAvailability.verify(fromModel: configModel) { verifed in
	/* If verifed == true, the application 
	   should be available to the user again,
	   e.g. you can go to the main screen */
} didTryAgain: {
	/* Re-retrieve the config 
	   and initialize its check again */
}
```

### Custom screen

To use your own config validation screen, create an object that conforms to the `ACVerifyViewControllerFactory` protocol:

```swift
public protocol ACVerifyViewControllerFactory {
    func makeTechnicalWorksAlert(tapTryAgain: (() -> Void)?) -> UIViewController
    func makeIosMinimalVersionAlert(tapOpenStore: (() -> Void)?) -> UIViewController
    func makeIosActualVersionAlert(tapOpenStore: (() -> Void)?, tapContinueWithoutUpdating: (() -> Void)?) -> UIViewController
    func presentViewController(_ viewController: UIViewController, from parentViewController: UIViewController?)
}
```

It handles the creation of a screen for different cases when checking application availability - when the server is unavailable due to technical work, when there is a required update to the application in the store, and when there is a new update but it is not required to be installed.

Pass it when creating `ACVerifyApplicationAvailability` to `viewControllerFactory`:

```swift
ACVerifyApplicationAvailability(
  parentViewController: parentScreen,
  viewControllerFactory: CustomVerifyViewControllerFactory()
)
```

You can also create a screen that inherits from `ACMessageViewController` and override the `decorate()` method to set your ui style to the components on that screen. 

For example:

```swift
class CustomMesageViewController: ACMessageViewController {
  override func decorate() {
    titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
  }
}
```

```swift
ACVerifyApplicationAvailability(
  parentViewController: parentScreen,
  viewControllerFactory: ACMessageViewControllerFactory.make(
    viewController: CustomMesageViewController()
  )
)
```

### Custom handler

If you create your own handler, make it compatible with the `ACVerifyHandler` protocol:

```swift
public protocol ACVerifyHandler {
    func verify(fromModel model: ACRemoteConfig?, completion: ((Bool) -> Void)?, didTryAgain: (() -> Void)?)
}
```

### Localization

If you only want to change the localization of components on the standard screen, you can pass the `ACMessageViewViewModel.LocaleConfiguration` object (by defining `.default()`) to the initializer:

```swift
ACMessageViewControllerFactory.make(
  viewController: ACMessageViewController(),
  localeConfiguration: <ACMessageViewModel.LocaleConfiguration>)
```

## License
This library is licensed under the MIT License.

## Author
Email: <moslienko.p@gmail.com> <br>
Email: <dmitriyap11@gmail.com> <br>
[Damian Bazhenov] (https://github.com/uxn0w)