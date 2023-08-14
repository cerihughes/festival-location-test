import Foundation
import UserNotifications

protocol NotificationsManager {
    func authorise() async -> Bool
    func sendLocalNotification(for event: Event)
}

class DefaultNotificationsManager: NSObject, NotificationsManager {
    private let dataRepository: DataRepository
    private let notificationCenter: UNUserNotificationCenter
    private let timeFormatter: DateFormatter

    init(dataRepository: DataRepository, notificationCenter: UNUserNotificationCenter, timeFormatter: DateFormatter) {
        self.dataRepository = dataRepository
        self.notificationCenter = notificationCenter
        self.timeFormatter = timeFormatter
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
        guard event.kind == .entry else { return }
        let content = UNMutableNotificationContent()
        let nowNext = dataRepository.nowNext(for: event.areaName)
        content.title = event.title
        content.body = nowNext.body(timeFormatter: timeFormatter)
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
        switch kind {
        case .entry:
            return "Arrived at \(areaName)"
        case .exit:
            return "Left \(areaName)"
        }
    }
}

private extension Optional where Wrapped == NowNext {
    func body(timeFormatter: DateFormatter) -> String {
        switch self {
        case .none:
            return "No more acts on this stage today."
        case let .some(nowNext):
            return nowNext.body(timeFormatter: timeFormatter)
        }
    }
}

private extension NowNext {
    func body(timeFormatter: DateFormatter) -> String {
        var body = nowBody(timeFormatter: timeFormatter)
        if let nextBody = nextBody(timeFormatter: timeFormatter) {
            body += "\n"
            body += nextBody
        }
        return body
    }

    private func nowBody(timeFormatter: DateFormatter) -> String {
        let prefix = isNowStarted ? "Now" : "Soon"
        return now.body(prefix: prefix, timeFormatter: timeFormatter)
    }

    private func nextBody(timeFormatter: DateFormatter) -> String? {
        guard let next else { return nil }
        return next.body(prefix: "Next", timeFormatter: timeFormatter)
    }
}

private extension Slot {
    func body(prefix: String, timeFormatter: DateFormatter) -> String {
        return "\(prefix) : \(timeString(timeFormatter: timeFormatter)) : \(name)"
    }
}
