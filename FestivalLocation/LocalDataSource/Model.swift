import Foundation

struct Location {
    let latitude: Double
    let longitude: Double
}

struct CircularArea {
    let location: Location
    let radius: Double
}

struct Visit {
    let start: Date
    let end: Date?
    let areaName: String
    let location: Location
}
