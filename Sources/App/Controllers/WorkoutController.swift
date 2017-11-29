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
        return try Workout.all().makeJSON()
    }
}
