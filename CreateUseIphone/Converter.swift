import Foundation
#if canImport(RoomPlan)
import RoomPlan
import simd

struct FloorPlanConverter {
    func convert(from room: CapturedRoom) -> FloorPlan {
        var plan = FloorPlan(title: "Scan \(Date.now.formatted(date: .abbreviated, time: .shortened))", createdAt: Date())
        if let bounds = room.boundary?.points {
            let corners: [V2] = bounds.map { V2(Double($0.x), Double($0.y)) }
            var r = Room(name: "Room", corners: corners); r.computeArea()
            plan.rooms = [r]
        }
        return plan
    }
}
#else
struct FloorPlanConverter { func convert(from _: Any) -> FloorPlan { FloorPlan.sample() } }
#endif
