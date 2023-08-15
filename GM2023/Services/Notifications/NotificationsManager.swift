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
        guard event.kind == .entry, let nowNext = dataRepository.nowNext(for: event.areaName) else { return }

        let content = UNMutableNotificationContent()
        content.title = event.title
        content.body = nowNext.body(timeFormatter: timeFormatter)
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = event.stringIdentifier
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: { error in
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
