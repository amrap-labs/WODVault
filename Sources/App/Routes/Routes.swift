import Vapor

extension Droplet {
    func setupRoutes() throws {
        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        // Workouts
        try resource("workouts", WorkoutController.self)
    }
}
