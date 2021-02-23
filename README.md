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

## [Пример 3. Модульная архитектура в SPM](https://github.com/ReQEnoxus/SwiftPM/tree/master/Projects/3.%20Modular%20Architecture%20with%20Storyboards)
В этом примере разбирается рефакторинг существующего монолитного приложения на отдельные модули. Приложение состоит из двух экранов: `Main`, содержащий список пользователей и `UserDetail`, позволяющий просмотреть детальную информацию о пользователе. Положение осложнено тем, что у нас уже есть 2 зависимости, подключенные через CocoaPods, а верстка реализована с помощью Storyboard:
<p align="center">
  <img src="Projects/3.%20Modular%20Architecture%20with%20Storyboards/.github/modular.png"/>
</p>

### Шаг 1. Отключение CocoaPods
Приложение содержит зависимости `RxSwift` и `Moya`, подключенные с помощью CocoaPods:
```ruby
target 'Modular' do
  use_frameworks!

  pod 'RxSwift', '~> 5.0.0'
  pod 'Moya', '~> 14.0'
end
```
Для того чтобы их удалить, нужно выполнить в корневой папке следующую команду:
```bash
pod deintegrate
```
После ее выполнения файл `Modular.xcworkspace` останется нетронутым, что позволит нам использовать его вместо создания собственного Workspace

### Шаг 2. Определение итоговой архитектуры
Целью проводимого рефакторинга является построение архитектуры, в которой каждый экран будет являться отдельным модулем со своими зависимостями. Аналогичным образом в отдельный модуль будут вынесены классы предметной области. Это позволит добиться более удобного переиспользования кода, а также ускорит сборку проекта, так как повторной сборке будут подвергнуты лишь те модули, которые реально были изменены. Схематично новую архитектуру можно изобразить в виде следующего графа:
<p align="center">
  <img src="Projects/3.%20Modular%20Architecture%20with%20Storyboards/.github/modular-graph.png"/ width="70%">
</p>

### Шаг 3. Создание модуля `Models`
Проще всего начать разделение именно отсюда, так как этот модуль не имеет зависимостей. Для создания нового модуля в текущем Workspace нужно выбрать следующую опцию, нажав на `+` в левом нижнем углу XCode:
<p align="center">
  <img src="Projects/3.%20Modular%20Architecture%20with%20Storyboards/.github/new-package.png"/ width="50%">
</p>

После этого нужно просто переместить файлы в созданную папку `Sources`, исправив, где нужно, модификаторы доступа на `public`
. `Package.swift` для этого модуля также будет выглядеть достаточно просто: <br>

```swift
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Models",
    products: [
        .library(
            name: "Models",
            targets: ["Models"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Models",
            dependencies: []
        ),
    ]
)
```

### Шаг 4. Создание модуля `UserDetail`
Здесь и далее не будем останавливаться на том, что уже рассматривалось в предыдущих шагах, отметим лишь то, что так как мы используем Storyboards, мы должны явно указать модуль, где содержится нужный нам кастомный класс для контроллера:

<p align="center">
  <img src="Projects/3.%20Modular%20Architecture%20with%20Storyboards/.github/class-module.png"/ width="50%">
</p>

Также, некоторые изменения нужно внести и в `Package.swift`. Из нерассмотренного ранее можно выделить подключение локального пакета в качестве зависимости:

```swift
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "UserDetail",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "UserDetail",
            targets: ["UserDetail"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.0.0")),
        .package(path: "../Models")  // <-- Подключение локального пакета
    ],
    targets: [
        .target(
            name: "UserDetail",
            dependencies: [
                "RxSwift",
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                "Models"
            ]),
    ]
)
```

### Шаг 5. Создание модуля `Main`
Здесь все аналогично, отличается он только тем, что в нем больше зависимостей:

```swift
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Main",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Main",
            targets: ["Main"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "14.0.0")),
        .package(path: "../Models"),
        .package(path: "../UserDetail")
    ],
    targets: [
        .target(
            name: "Main",
            dependencies: [
                "RxSwift",
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                "Moya",
                "Models",
                "UserDetail"
            ]
        ),
    ]
)
```
### Шаг 6. Подключение модуля `Main`
Исходя из построенной схемы, единственной прямой зависимостью приложения является модуль `Main`. Все остальные зависимости будут являться транзитивными. Для подключения модуля добавим его в `Frameworks, Libraries, and Embedded Content` нашего таргета:
<p align="center">
  <img src="Projects/3.%20Modular%20Architecture%20with%20Storyboards/.github/add-main.png"/ width="70%">
</p>

### Шаг 7. Установка rootViewController
Так как Storyboard модуля `Main` больше не находится в основном бандле приложения, мы больше не можем просто указывать его имя в `Info.plist` для установки стартового экрана. Воспользуемся следующим хелпером, чтобы установить его:

```swift
public class MainViewController: UIViewController {  
    public static func instantiate() -> UIViewController? {
        return UIStoryboard(name: "Main", bundle: .module).instantiateInitialViewController()
    }
}
```

После этого в `SceneDelegate`:
```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = MainViewController.instantiate()
        window?.makeKeyAndVisible()
    }
}
```
### Шаг 8. Настройка Segue
Переход между модулями `Main` и `UserDetail` осуществляется с помощью Segue:
<p align="center">
  <img src="Projects/3.%20Modular%20Architecture%20with%20Storyboards/.github/st-ref.png"/>
</p>

Для того, чтобы этот способ работал в модульной архитектуре, нам нужно вручную указать идентификатор бандла для объекта `Storyboard Reference`. Идентификатор бандла модуля в SPM формируется следующим образом: `[Package Name]-[Target Name]-resources`:
<p align="center">
  <img src="Projects/3.%20Modular%20Architecture%20with%20Storyboards/.github/bundle-id.png"/>
</p>

Кроме того, одно лишь указание бандла в этом объекте не гарантирует его доступность в runtime. Для того, чтобы не получить краш при выполнении перехода на экран деталки необходимо вручную загрузить соответствующий бандл. Для этого создадим следующий хэлпер в модуле `UserDetail`:
```swift
//
//  BundleUtil.swift
//  

import Foundation

public class UserDetailBundle {
    public static func load() {
        Bundle.module.load()
    }
}
```

И вызовем его в `AppDelegate`:
```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDetailBundle.load()
        return true
    }
}
```
<br>
На этом шаге рефакторинг завершается, приложение готово к использованию

# Полезные ссылки
* [Официальная документация](https://swift.org/package-manager)
* [WWDC - Обзор SPM](https://developer.apple.com/videos/play/wwdc2018/411)
* [WWDC - Использование пакетов](https://developer.apple.com/videos/play/wwdc2019/408)
* [WWDC - Создание пакетов](https://developer.apple.com/videos/play/wwdc2019/410)
* [WWDC - Ресурсы в SPM](https://developer.apple.com/videos/play/wwdc2020/10169)
