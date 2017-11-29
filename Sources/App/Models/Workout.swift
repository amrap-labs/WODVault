import Vapor
import FluentProvider
import HTTP

final class Workout: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    var date: Date
    
    // Database columns
    struct Keys {
        static let id = "id"
        static let date = "date"
    }
    
    init(date: Date) {
        self.date = date
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the Post from the
    /// database row
    init(row: Row) throws {
        date = try row.get(Workout.Keys.date)
    }
    
    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Workout.Keys.date, date)
        return row
    }
}

extension Workout: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Workout.Keys.date)
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: - JSON
extension Workout: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            date: try json.get(Workout.Keys.date)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Workout.Keys.date, date)
        return json
    }
}
