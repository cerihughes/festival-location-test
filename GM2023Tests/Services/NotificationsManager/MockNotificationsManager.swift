import Foundation

@testable import GM2023

class MockNotificationsManager: NotificationsManager {
    var lastAuthorisationStatus: Bool?

    var authoriseResult = false
    func authorise() async -> Bool {
        authoriseResult
    }

    func sendLocalNotification(for event: Event) {}
}
