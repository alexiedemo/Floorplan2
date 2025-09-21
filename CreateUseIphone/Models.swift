import Foundation
import simd

struct FloorPlan: Identifiable, Codable {
    var id = UUID()
    var title: String
    var createdAt: Date
    var rooms: [Room] = []
    var walls: [Wall] = []
    var openings: [Opening] = []
    
    var subtitle: String {
        "\(rooms.count) rooms • \(Int(totalArea())) m²"
    }
    
    func totalArea() -> Double {
        rooms.map { $0.area }.reduce(0, +)
    }
    
    static func sample() -> FloorPlan {
        var r1 = Room(name: "Living", corners: [V2(0,0), V2(5,0), V2(5,4), V2(0,4)])
        r1.computeArea()
        return FloorPlan(title: "Sample Plan", createdAt: Date(), rooms: [r1], walls: [], openings: [])
    }
}

struct Room: Identifiable, Codable {
    var id = UUID()
    var name: String
    var corners: [V2]
    var area: Double = 0.0
    
    mutating func computeArea() {
        area = polygonArea(corners)
    }
}

struct Wall: Identifiable, Codable {
    var id = UUID()
    var start: V2
    var end: V2
    var thickness: Double
}

struct Opening: Identifiable, Codable {
    var id = UUID()
    var position: V2
    var width: Double
    var kind: OpeningKind
}

enum OpeningKind: String, Codable { case door, window }

struct V2: Codable, Hashable {
    var x: Double
    var y: Double
    init(_ x: Double, _ y: Double) { self.x = x; self.y = y }
}

func polygonArea(_ pts: [V2]) -> Double {
    guard pts.count >= 3 else { return 0 }
    var s = 0.0
    for i in 0..<pts.count {
        let a = pts[i], b = pts[(i+1) % pts.count]
        s += a.x * b.y - b.x * a.y
    }
    return abs(s) * 0.5
}
