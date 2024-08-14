import Foundation

extension String {
    static let greenMan2024FestivalAreas = "GreenMan2023-Areas.json"
    static let greenMan2024FestivalLineup = "GreenMan2023-Lineup.txt"
}

extension URL {
    static let github = "https://raw.githubusercontent.com/cerihughes/festival-location-test/main/GM2023/"
    static let greenMan2024FestivalAreas = URL(string: github + String.greenMan2024FestivalAreas)!
    static let greenMan2024FestivalLineup = URL(string: github + String.greenMan2024FestivalLineup)!
}

class LocalDataLoader {
    private let fileName: String

    private init(fileName: String) {
        self.fileName = fileName
    }

    func loadData() -> Data? {
        guard let url = Bundle.main.url(for: fileName) else { return nil }
        return try? .init(contentsOf: url)
    }

    static func fileName(_ fileName: String) -> LocalDataLoader {
        .init(fileName: fileName)
    }
}

class RemoteDataLoader {
    private let url: URL

    private init(url: URL) {
        self.url = url
    }

    func loadData() async -> Data? {
        try? await URLSession.shared.data(from: url).0
    }

    static func url(_ url: URL) -> RemoteDataLoader {
        .init(url: url)
    }
}
