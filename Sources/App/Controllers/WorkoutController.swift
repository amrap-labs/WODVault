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
        guard let boxId = request.data[Workout.Keys.boxId]?.string else {
            return Response(status: .badRequest)
        }
        
        let results = try Workout.makeQuery().filter(Workout.Keys.boxId, .equals, boxId).all()
        guard results.count > 0 else {
            return Response(status: .notFound)
        }
        
        return try results.makeJSON()
    }
}
