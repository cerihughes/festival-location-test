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

        if let locationMonitor {
            locationMonitor.start()
        }

        let context = madog.renderUI(identifier: .tabBarNavigation(), tokenData: .multi([.addArea]), in: window)
        return context != nil
    }

    private var locationMonitor: LocationMonitor? {
        guard let services = madog.serviceProviders[serviceProviderName] as? Services else { return nil }
        return services.locationMonitor
    }
}

#if DEBUG
extension UIApplicationDelegate {
    var isRunningUnitTests: Bool {
        UserDefaults.standard.bool(forKey: "isRunningUnitTests")
    }
}
#endif
