import Foundation
import UserNotifications

protocol NotificationsManager {
    func authorise() async -> Bool
    func sendLocalNotification(for event: Event)
}

class DefaultNotificationsManager: NSObject, NotificationsManager {
    private let notificationCenter: UNUserNotificationCenter
    private let dateFormatter: DateFormatter

    init(notificationCenter: UNUserNotificationCenter, dateFormatter: DateFormatter) {
        self.notificationCenter = notificationCenter
        self.dateFormatter = dateFormatter
        super.init()
        notificationCenter.delegate = self
    }

    func authorise() async -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound]
        do {
            return try await notificationCenter.requestAuthorization(options: options)
        } catch {
            return false
        }
    }

    func sendLocalNotification(for event: Event) {
        let content = UNMutableNotificationContent()
        content.title = event.title
        content.body = event.body(dateFormatter: dateFormatter)
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = event.stringIdentifier
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("Error adding notification with identifier: \(identifier)")
            }
        })
    }
}

extension DefaultNotificationsManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.list, .banner]
    }
}

private extension Event {
    var title: String {
        kind.notificationTitle
    }

    func body(dateFormatter: DateFormatter) -> String {
        "\(areaName): \(kind.notificationBody) at \(dateFormatter.string(from: timestamp))"
    }
}

private extension Optional where Wrapped == Event.Kind {
    var notificationTitle: String {
        switch self {
        case .none:
            return "Unknown"
        case .entry:
            return "Arrived"
        case .exit:
            return "Left"
        }
    }

    var notificationBody: String {
        switch self {
        case .none:
            return "Unknown event"
        case .entry:
            return "Arrived"
        case .exit:
            return "Left"
        }
    }
}
