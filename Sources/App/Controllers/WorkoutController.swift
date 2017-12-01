import Vapor
import HTTP

final class WorkoutController: ResourceRepresentable {
    
    // MARK: ResourceRepresentable
    
    func makeResource() -> Resource<Workout> {
        return Resource(
            index: loadAll
        )
    }
    
    // MARK: Resource Methods
    
    func loadAll(_ request: Request) throws -> ResponseRepresentable {
        if let badResponse = request.isMissingData(for: [Workout.Keys.boxId]) {
            return badResponse
        }
        
        let boxId = request.data[Workout.Keys.boxId]?.string
        
        let query = try Workout.makeQuery().filter(Workout.Keys.boxId, .equals, boxId)
        let results = try query.paginate(for: request)
        guard results.data.count > 0 else {
            return ErrorResponse(status: .notFound)
        }
        
        return try results.makeJSON()
    }
}

extension WorkoutController: EmptyInitializable {
}
