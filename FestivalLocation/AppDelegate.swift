import Madog
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let madog = Madog<Navigation>()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow()
        window.makeKeyAndVisible()

        self.window = window

        #if DEBUG
        if isRunningUnitTests {
            window.rootViewController = UIViewController()
            return true
        }
        #endif

        madog.resolve(resolver: DefaultResolver())
        let context = madog.renderUI(identifier: .tabBarNavigation(), tokenData: .multi([.areas]), in: window)
        return context != nil
    }
}

#if DEBUG
extension UIApplicationDelegate {
    var isRunningUnitTests: Bool {
        UserDefaults.standard.bool(forKey: "isRunningUnitTests")
    }
}
#endif
