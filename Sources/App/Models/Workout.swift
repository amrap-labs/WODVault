import Vapor
import FluentProvider
import HTTP

final class Workout: Model {
    let storage = Storage()
    
    static let idType: IdentifierType = .uuid
    
    // MARK: Properties and database keys
    
    private(set) var guid: String
    private(set) var title: String
    private(set) var publishDate: Date
    private(set) var rawDescription: String
    private(set) var link: String
    
    // Database columns
    struct Keys {
        static let guid = "guid"
        static let title = "title"
        static let publishDate = "pubDate"
        static let rawDescription = "rawDescription"
        static let link = "link"
    }
    
    init(guid: String,
         title: String,
         publishDate: Date,
         rawDescription: String,
         link: String) {
        self.guid = guid
        self.title = title
        self.publishDate = publishDate
        self.rawDescription = rawDescription
        self.link = link
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the Post from the
    /// database row
    init(row: Row) throws {
        guid = try row.get(Workout.Keys.guid)
        title = try row.get(Workout.Keys.title)
        publishDate = try row.get(Workout.Keys.publishDate)
        rawDescription = try row.get(Workout.Keys.rawDescription)
        link = try row.get(Workout.Keys.link)
    }
    
    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Workout.Keys.guid, guid)
        try row.set(Workout.Keys.title, title)
        try row.set(Workout.Keys.publishDate, publishDate)
        try row.set(Workout.Keys.rawDescription, rawDescription)
        try row.set(Workout.Keys.link, link)
        return row
    }
}

extension Workout: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Workout.Keys.guid)
            builder.string(Workout.Keys.title)
            builder.date(Workout.Keys.publishDate)
            builder.string(Workout.Keys.rawDescription)
            builder.string(Workout.Keys.link)
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
            guid: try json.get(Workout.Keys.guid),
            title: try json.get(Workout.Keys.title),
            publishDate: try json.get(Workout.Keys.publishDate),
            rawDescription: try json.get(Workout.Keys.rawDescription),
            link: try json.get(Workout.Keys.link)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Workout.Keys.guid, guid)
        try json.set(Workout.Keys.title, title)
        try json.set(Workout.Keys.publishDate, publishDate)
        try json.set(Workout.Keys.rawDescription, rawDescription)
        try json.set(Workout.Keys.link, link)
        return json
    }
}
