import UIKit

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach(addSubview)
    }

    func addSubviews(_ subviews: UIView...) {
        addSubviews(subviews)
    }
}

extension UIButton {
    static func settingsButton(title: String) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .cellBackground1
        button.setTitle(title, for: .normal)
        return button
    }
}

extension UIColor {
    static let cellBackground1 = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    static let cellBackground2 = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
}
