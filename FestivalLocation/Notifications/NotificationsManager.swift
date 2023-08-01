import Foundation
import UserNotifications

protocol NotificationsManager {
    func sendLocalNotification(for visit: Visit)
}

class DefaultNotificationsManager: NotificationsManager {
    let notificationCenter: UNUserNotificationCenter

    init(notificationCenter: UNUserNotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    func sendLocalNotification(for visit: Visit) {
        let content = UNMutableNotificationContent()
        content.title = visit.title
        content.body = visit.body
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = visit._id.stringValue
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("Error adding notification with identifier: \(identifier)")
            }
        })
    }
}

private extension Visit {
    var title: String {
        kind.notificationTitle
    }

    var body: String {
        "\(kind.notificationBody) \(name)"
    }
}

private extension Optional where Wrapped == Visit.Kind {
    var notificationTitle: String {
        switch self {
        case .none:
            return "Unknown interaction"
        case .entry:
            return "Arrived"
        case .exit:
            return "Left"
        }
    }

    var notificationBody: String {
        switch self {
        case .none:
            return "Unknown interaction at area:"
        case .entry:
            return "Arrived at area:"
        case .exit:
            return "Left area:"
        }
    }
}
