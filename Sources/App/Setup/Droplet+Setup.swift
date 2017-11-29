@_exported import Vapor

extension Droplet {
    public func setup() throws {
        try setupRoutes()
        // Do any additional droplet setup
        
        // Workout Reader
        let feeds = (config["sources", "feeds"]?.array ?? []).flatMap({ $0.string })
        let readerService = WorkoutReaderService(for: feeds)
    }
}
