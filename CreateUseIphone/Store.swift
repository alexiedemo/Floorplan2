import Foundation

@MainActor
final class ScanStore: ObservableObject {
    @Published var plans: [FloorPlan] = []
    private let storage = Storage()
    init() { plans = (try? storage.load()) ?? [] }
    func save(plan: FloorPlan) { plans.append(plan); try? storage.save(plans) }
    func delete(at offsets: IndexSet) { plans.remove(atOffsets: offsets); try? storage.save(plans) }
}

struct Storage {
    private var url: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("plans.json")
    }
    func save(_ plans: [FloorPlan]) throws { let data = try JSONEncoder().encode(plans); try data.write(to: url) }
    func load() throws -> [FloorPlan] { let data = try Data(contentsOf: url); return try JSONDecoder().decode([FloorPlan].self, from: data) }
}
