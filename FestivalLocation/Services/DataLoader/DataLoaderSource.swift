import Foundation

extension String {
    static let greenMan2023FestivalAreas = "GreenMan2023-Areas.json"
    static let greenMan2023FestivalLineup = "GreenMan2023-Lineup.txt"
}

extension URL {
    static let github = "https://raw.githubusercontent.com/cerihughes/festival-location-test/main/FestivalLocation/"
    static let greenMan2023FestivalAreas = URL(string: github + String.greenMan2023FestivalAreas)!
    static let greenMan2023FestivalLineup = URL(string: github + String.greenMan2023FestivalLineup)!
}

enum DataLoaderSource {
    case local(String)
    case remote(URL)
}

extension DataLoaderSource {
    func loadData() -> Data? {
        switch self {
        case let .local(fileName):
            return loadLocalData(fileName: fileName)
        case let .remote(url):
            return loadRemoteData(url: url)
        }
    }

    private func loadLocalData(fileName: String) -> Data? {
        guard let url = Bundle.main.url(for: fileName) else { return nil }
        return try? .init(contentsOf: url)
    }

    private func loadRemoteData(url: URL) -> Data? {
        try? .init(Data(contentsOf: url))
    }
}
