@_exported import Vapor
import Jobs

extension Droplet {
    public func setup() throws {
        try setupRoutes()
        setupJobs()
        
        // Do any additional droplet setup
    }
}
