# ACRemoteConfig

[![Swift](https://img.shields.io/badge/Swift-5-orange?style=flat-square)](https://img.shields.io/badge/Swift-5-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
[![version](https://img.shields.io/badge/version-1.0.1-white.svg)](https://semver.org)

## Requirements
- Xcode 13 and later
- iOS 11 and later
- Swift 5.0 and later

## Overview
* [Demo](#demo)
* [Install](#install)

## Basic
### Config file

Получите или создайте конфиг любым способом, если он размещен через Firebase Remote Config то можно воспользоваться следующим [классом](/Demo/ACRemoteConfigDemo/ServiceLayer/FirebaseRemoteConfigService.swift) из [Demo](#demo). Файл конфига должен соответствовать протоколу `ACRemoteConfig`:

```swift
public protocol ACRemoteConfig {
  var iosActualVersion: String { get }
  var iosMinimalVersion: String { get }
  var technicalWorks: Bool { get }
}
```

### Verify config

В стандартном варианте нужно создать объект класса `ACVerifyApplicationAvailability`:

```swift
init(
  parentViewController: UIViewController?,
  urlToAppInAppStore: URL?
)
```

И передать туда модель конфига:

```swift
let verifyApplicationAvailability = ACVerifyApplicationAvailability(parentViewController: parentScreen)

verifyApplicationAvailability.verify(fromModel: configModel) { verifed in
	// При verifed == true приложение должно быть снова доступно пользователю, например можно перейти к главному экрану
} didTryAgain: {
	// Выполните повторное получение конфига и снова инициализируйте его проверку
}
```

### Custom screen

Для использования своего собственного экран валидации конфига, создайте объект, соответствующий протоколу `ACVerifyViewControllerFactory`:

```swift
public protocol ACVerifyViewControllerFactory {
    func makeTechnicalWorksAlert(tapTryAgain: (() -> Void)?) -> UIViewController
    func makeIosMinimalVersionAlert(tapOpenStore: (() -> Void)?) -> UIViewController
    func makeIosActualVersionAlert(tapOpenStore: (() -> Void)?, tapContinueWithoutUpdating: (() -> Void)?) -> UIViewController
    func presentViewController(_ viewController: UIViewController, from parentViewController: UIViewController?)
}
```

В нем обрабатывается создание экрана для различных случаев при проверке доступности приложения - в случае недоступности сервера из-за технических работа или вообще, когда есть обязательное обновление приложения в сторе, и когда новое обновление есть, но оно не обязательно к установке.

Передайте его при создании `ACVerifyApplicationAvailability` в `viewControllerFactory`:

```swift
ACVerifyApplicationAvailability(
  parentViewController: parentScreen,
  viewControllerFactory: CustomVerifyViewControllerFactory()
)
```

Так же можно создать экран, наследующий от `ACMessageViewController` и переопределить метод `decorate()` для задания своего стиля ui компонентам на этом экране. Например:

```swift
class CustomMesageViewController: ACMessageViewController {
  override func decorate() {
    titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
  }
}
```

### Localization

Если нужно изменить только локализацию компонентов на стандартном экране, можно передать в инициализатор объект `ACMessageViewModel.LocaleConfiguration` (по умолчанию `.default()`)

```swift
ACMessageViewControllerFactory.make(
  viewController: ACMessageViewController(),
  localeConfiguration: <ACMessageViewModel.LocaleConfiguration>)
```

### Custom handler

Если вы создаете свой собственный обработчик, сделайте его совестимым протоколу `ACVerifyHandler`:

```swift
public protocol ACVerifyHandler {
    func verify(fromModel model: ACRemoteConfig?, completion: ((Bool) -> Void)?, didTryAgain: (() -> Void)?)
}
```

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

## License
This library is licensed under the MIT License.

## Author
Email: <moslienko.p@gmail.com> <br>
[Damian Bazhenov] (https://github.com/uxn0w)