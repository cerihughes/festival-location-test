import Foundation

struct Location {
    let lat: Double
    let lon: Double
}

struct Visit {
    let start: Date
    let end: Date?
    let areaName: String
    let location: Location
}
