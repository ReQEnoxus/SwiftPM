# SwiftPM
Репозиторий с дополнительными материалами по [докладу](https://docs.google.com/presentation/d/1ZJzVk92yq-fPrW6IqfwV4fPY-eCNTL97rntQqj5aVpw/edit?usp=sharing) о Swift Package Manager с iOS-митапа в Технократии
## [Пример 1. Simple Dependency](https://github.com/ReQEnoxus/SwiftPM/tree/master/Projects/1.%20Simple%20Dependency)
В этом примере рассматривается подключение к проекту зависимости `SwiftNotificationBanner` через SPM. Эта библиотека позволяет отображать на экране баннеры следующим образом: <br>
<p align="center">
  <img src="Projects/1.%20Simple%20Dependency/.github/Application.png" width="30%" height="30%"/>
</p>

### Шаг 1. Добавление зависимости
<p align="center">
  <img src="Projects/1.%20Simple%20Dependency/.github/Step1.png"/>
</p>

### Шаг 2. Выбор версии
<p align="center">
  <img src="Projects/1.%20Simple%20Dependency/.github/Step2.png"/>
</p>

### Шаг 3. Добавление библиотеки к таргету
<p align="center">
  <img src="Projects/1.%20Simple%20Dependency/.github/Step3.png"/>
</p>

### Шаг 4. Использование
```swift
import UIKit
import NotificationBannerSwift

class ViewController: UIViewController {
    @IBAction func buttonTouchUpInside(_ sender: Any) {
        NotificationBanner(
            title: "NotificationBannerSwift",
            subtitle: "imported by spm",
            leftView: nil,
            rightView: nil,
            style: .success,
            colors: nil
        )
        .show(
            queuePosition: .front,
            bannerPosition: .top,
            queue: .default
        )
    }
}
```
## [Пример 2. Bundle With Resources](https://github.com/ReQEnoxus/SwiftPM/tree/master/Projects/2.%20Bundle%20with%20resources)
В этом примере рассматривается создание библиотеки, использующей статические ресурсы в виде картинок и локализации. Библиотека предоставляет пользователю экран с изображением рамки и кнопкой загрузки картинки. При этом название кнопки зависит от локализации.
<p align="center">
  <img src="Projects/2.%20Bundle%20with%20resources/.github/Lib1.png"/ width="40%" height="40%">
  <img src="Projects/2.%20Bundle%20with%20resources/.github/Lib2.png"/ width="40%" height="40%">
</p>

### Шаг 1. Инициализация
Шаблон библиотеки можно создать с помощью консольной команды:
```bash
swift package init --type library
```

### Шаг 2. Package.swift
При составлении манифеста добавляем:
* `defaultLocalization: "en"`, так как при использовании файлов локализации необходимо указать, какую локализацию нужно использовать по умолчанию
* `platforms: [.iOS(.v11)]`, так как наша библиотека использует `UIKit`
* `dependencies: [.package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))]`, так как для верстки используется `SnapKit`
```swift
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Lib",
    defaultLocalization: "en",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "Lib",
            targets: ["Lib"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
    ],
    targets: [
        .target(
            name: "Lib",
            dependencies: ["SnapKit"]
        ),
    ]
)
```

### Шаг 3. Реализация
Общий вид файловой структуры таргета:
```bash
Lib
├── RandomPictureController
│   └── RandomPictureController.swift
└── Resources
    ├── Images.xcassets
    │   ├── Contents.json
    │   └── frame.imageset
    │       ├── Contents.json
    │       └── frame.png
    └── Localization
        ├── en.lproj
        │   └── Localizable.strings
        └── ru.lproj
            └── Localizable.strings
```

Так как статические ресурсы находятся в папке `Resources`, а их предназначение очевидно по их расширениям - `.lproj`, `.xcassets`, мы не должны особым образом указывать их в `Package.swift`. <br> <br>
Также необходимо помнить, что для доступа к локальным ресурсам модуля нужно использовать конструкцию `Bundle.module`, доступную начиная со Swift 5.3:
```swift
//
//  RandomPictureController.swift
//  

public final class RandomPictureController: UIViewController {
    
    private lazy var getNewPictureButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle(
            NSLocalizedString(
                "button.title",
                bundle: .module, // <-- Bundle.module
                comment: "Title of the button"
            ),
            for: .normal
        )

        return button
    }()
    
    private lazy var frameImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = UIImage(
            named: "frame",
            in: .module, // <-- Bundle.module
            compatibleWith: nil
        )

        return imageView
    }()
}
```
# Полезные ссылки
* [Официальная документация](https://swift.org/package-manager)
* [WWDC - Обзор SPM](https://developer.apple.com/videos/play/wwdc2018/411)
* [WWDC - Использование пакетов](https://developer.apple.com/videos/play/wwdc2019/408)
* [WWDC - Создание пакетов](https://developer.apple.com/videos/play/wwdc2019/410)
* [WWDC - Ресурсы в SPM](https://developer.apple.com/videos/play/wwdc2020/10169)
