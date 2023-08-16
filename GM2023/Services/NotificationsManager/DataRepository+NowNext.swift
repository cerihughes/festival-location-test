import Foundation

struct NowNext {
    let isNowStarted: Bool
    let now: Slot
    let next: Slot?
}

extension DataRepository {
    func nowNext(for stage: GMStage) -> NowNext? {
        nowNext(for: stage.identifier)
    }

    func nowNext(for stageName: String) -> NowNext? {
        let current = dateFactory.currentDate()

        guard
            let slots = stage(name: stageName)?.todaySlots,
            let now = slots.filter({ $0.end > current }).first
        else { return nil }

        let isNowStarted = now.start < current
        let next = slots.element(after: now)
        return .init(isNowStarted: isNowStarted, now: now, next: next)
    }
}
