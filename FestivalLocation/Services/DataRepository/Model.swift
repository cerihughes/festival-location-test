import Foundation

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

struct CircularArea: Codable {
    let name: String
    let location: Location
    let radius: Double
}

struct Visit {
    let start: Date
    let end: Date?
    let areaName: String
    let location: Location
}
