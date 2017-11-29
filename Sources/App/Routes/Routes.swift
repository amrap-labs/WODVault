import Vapor

extension Droplet {
    func setupRoutes() throws {
        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        try resource("posts", PostController.self)
        
        // Workouts
        let workoutController = WorkoutController()
        resource("workouts", workoutController)
        get("workouts", "*") { request in
            return try workoutController.loadAll(request)
        }
    }
}
