import Foundation

protocol LineupLoader {
    func importLineup(data: Data) -> Bool
}

extension LineupLoader {
    func importLineup(loader: LocalDataLoader) -> Bool {
        guard let data = loader.loadData() else { return false }
        return importLineup(data: data)
    }

    @MainActor
    func importLineup(loader: RemoteDataLoader) async -> Bool {
        guard let data = await loader.loadData() else { return false }
        return importLineup(data: data)
    }
}

class DefaultLineupLoader: LineupLoader {
    let builder: LineupBuilder

    init(dataRepository: DataRepository) {
        builder = LineupBuilder(dataRepository: dataRepository)
    }

    func importLineup(data: Data) -> Bool {
        guard let string = String(data: data, encoding: .utf8) else { return false }
        builder.createFestival(name: .greenMan2023FestivalName)

        let lines = string.split(separator: "\n")
        for line in lines {
            let result = parseLine(String(line))
            if result == false {
                return false
            }
        }
        return true
    }

    private func parseLine(_ line: String) -> Bool {
        guard !line.isEmpty else { return true } // Empty lines are ignored

        if let dateString = line.removingPrefix("*") { // New date
            return builder.setCurrentDate(dateString)
        }

        if let stageName = line.removingPrefix(">") { // New stage
            return builder.setCurrentStage(stageName)
        }

        return builder.setStartEndTimes(line) || builder.setSlotName(line)
    }
}

private extension String {
    func removingPrefix(_ prefix: String) -> String? {
        guard self.hasPrefix(prefix) else { return nil }
        let index = index(startIndex, offsetBy: prefix.count)
        return String(suffix(from: index))
    }
}

private struct StartEndTimes {
    let startTime: String
    let endTime: String
}

class LineupBuilder {
    private let dataRepository: DataRepository
    private let dateFormatter = DateFormatter.dd_MM_yyyy()
    private let timeFormatter = DateFormatter.dd_MM_yyyy_HH_mm()

    private var currentDateString: String?
    private var currentStartEndTimes: StartEndTimes?
    private var lastEndTime: Date?

    private var currentFestival: Festival?
    private var currentStage: Stage?

    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
    }

    func createFestival(name: String) {
        currentFestival = dataRepository.recreateFestival(name: name)
    }

    func setCurrentDate(_ currentDateString: String) -> Bool {
        guard dateFormatter.date(from: currentDateString) != nil else { return false }
        self.currentDateString = currentDateString
        return true
    }

    func setCurrentStage(_ currentStageName: String) -> Bool {
        guard let currentFestival else { return false }
        resetStage()
        currentStage = dataRepository.getOrCreateStage(in: currentFestival, name: currentStageName)
        return true
    }

    func setStartEndTimes(_ startEndTimes: String) -> Bool {
        guard currentStartEndTimes == nil, let startEndTimes = startEndTimes.asStartEndTimes() else { return false }
        self.currentStartEndTimes = startEndTimes
        return true
    }

    func setSlotName(_ slotName: String) -> Bool {
        guard let currentDateString, let currentStartEndTimes else { return false }
        resetSlot()
        return createSlot(
            name: slotName,
            currentDateString: currentDateString,
            startTime: currentStartEndTimes.startTime,
            endTime: currentStartEndTimes.endTime
        )
    }

    private func createSlot(name: String, currentDateString: String, startTime: String, endTime: String) -> Bool {
        let startDateTime = "\(currentDateString) \(startTime)"
        let endDateTime = "\(currentDateString) \(endTime)"
        guard
            let currentStage,
            var start = timeFormatter.date(from: startDateTime),
            var end = timeFormatter.date(from: endDateTime)
        else {
            return false
        }
        if let lastEndTime, start < lastEndTime {
            // for listings that start at / after midnight
            start = start.addingOneDay()
            end = end.addingOneDay()
        }
        if end < start {
            // for listings that start before midnight but end at / after midnight.
            end = end.addingOneDay()
        }
        dataRepository.createSlot(name: name, start: start, end: end, on: currentStage)
        lastEndTime = end
        return true
    }

    func reset() {
        currentDateString = nil
        currentFestival = nil
        resetStage()
        resetSlot()
    }

    func resetStage() {
        currentStage = nil
        lastEndTime = nil
    }

    func resetSlot() {
        currentStartEndTimes = nil
    }
}

private extension String {
    func asStartEndTimes() -> StartEndTimes? {
        let splits = split(separator: "-")
            .map { String($0).trimmed }
        guard splits.count == 2, let startTime = splits.first, let endTime = splits.last else { return nil }
        return .init(startTime: startTime, endTime: endTime)
    }
}
