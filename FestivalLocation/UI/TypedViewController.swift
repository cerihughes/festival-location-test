import UIKit

class TypedViewController<V: UIView>: UIViewController {
    let typedView = V()

    override func loadView() {
        view = typedView
    }
}
