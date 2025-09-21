import Foundation
#if canImport(RoomPlan)
import RoomPlan

@available(iOS 16.0, *)
struct FloorPlanConverter {
    func convert(from room: CapturedRoom) -> FloorPlan {
        // Version-agnostic stub conversion to keep CI builds portable.
        var plan = FloorPlan(title: "Scan " + Date.now.formatted(date: .abbreviated, time: .shortened), createdAt: Date())
        var r = Room(name: "Room", corners: [V2(0,0), V2(5,0), V2(5,4), V2(0,4)])
        r.computeArea(); plan.rooms = [r]; return plan
    }
}
#else
struct FloorPlanConverter { func convert(from _: Any) -> FloorPlan { FloorPlan.sample() } }
#endif
