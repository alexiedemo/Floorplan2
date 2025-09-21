import Foundation
#if canImport(RoomPlan)
import RoomPlan
import simd

/// Converts Apple's CapturedRoom into our FloorPlan model.
struct FloorPlanConverter {
    func convert(from room: CapturedRoom) -> FloorPlan {
        var plan = FloorPlan(title: "Scan \(Date.now.formatted(date: .abbreviated, time: .shortened))", createdAt: Date())
        // Very basic conversion: add one room bounds if available
        if let bounds = room.boundary?.points {
            let corners: [V2] = bounds.map { V2(Double($0.x), Double($0.y)) }
            var r = Room(name: "Room", corners: corners)
            r.computeArea()
            plan.rooms = [r]
        }
        // Add doors/windows from openings if provided
        if let openings = room.openings {
            plan.openings = openings.map { Opening(position: V2(Double($0.position.x), Double($0.position.y)), width: Double($0.width), kind: .door) }
        }
        return plan
    }
}
#else
struct FloorPlanConverter {
    func convert(from _: Any) -> FloorPlan {
        FloorPlan.sample()
    }
}
#endif
