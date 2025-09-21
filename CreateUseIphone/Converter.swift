import Foundation
#if canImport(RoomPlan)
import RoomPlan

@available(iOS 16.0, *)
struct FloorPlanConverter {
    func convert(from room: CapturedRoom) -> FloorPlan {
        // Very basic conversion: approximate a rectangular room from the extents of walls if available
        var plan = FloorPlan(title: "Scan " + Date.now.formatted(date: .abbreviated, time: .shortened), createdAt: Date())
        var corners: [V2] = []
        // Try to infer extents from walls if present
        if !room.walls.isEmpty {
            var minX = Double.greatestFiniteMagnitude, minY = Double.greatestFiniteMagnitude
            var maxX = -Double.greatestFiniteMagnitude, maxY = -Double.greatestFiniteMagnitude
            for w in room.walls {
                let a = w.startingPoint, b = w.endPoint
                minX = min(minX, Double(a.x), Double(b.x))
                minY = min(minY, Double(a.y), Double(b.y))
                maxX = max(maxX, Double(a.x), Double(b.x))
                maxY = max(maxY, Double(a.y), Double(b.y))
            }
            if minX.isFinite, minY.isFinite, maxX.isFinite, maxY.isFinite, maxX > minX, maxY > minY {
                corners = [V2(minX,minY), V2(maxX,minY), V2(maxX,maxY), V2(minX,maxY)]
            }
        }
        if corners.isEmpty {
            // Fallback rectangle if no geometry is available
            corners = [V2(0,0), V2(5,0), V2(5,4), V2(0,4)]
        }
        var r = Room(name: "Room", corners: corners)
        r.computeArea()
        plan.rooms = [r]
        return plan
    }
}
#else
struct FloorPlanConverter { func convert(from _: Any) -> FloorPlan { FloorPlan.sample() } }
#endif
