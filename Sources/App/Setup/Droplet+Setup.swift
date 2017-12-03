@_exported import Vapor
import Jobs

extension Droplet {
    public func setup() throws {
        try setupRoutes()
        // Do any additional droplet setup
        
        // Workout Reader job
        let feeds = (config["sources"]?.array ?? []).flatMap({ WorkoutReaderSource(config: $0) })
        Jobs.add(interval: .seconds(900)) {
            let readerService = WorkoutReaderService.shared(for: feeds, log: self.log)
            readerService.updateAll()
        }
    }
}
