//
//  WorkoutReader.swift
//  WODVaultPackageDescription
//
//  Created by Merrick Sapsford on 29/11/2017.
//

import Foundation
import FeedKit

protocol WorkoutReaderDelegate: class {
    
    func reader(_ reader: WorkoutReader, didBeginUpdating feedUrl: URL)
    
    func reader(_ reader: WorkoutReader, didFailToUpdate feedUrl: URL, becauseOf error: Error)
    
    func reader(_ reader: WorkoutReader, didLoad workouts: [Workout], newDiscoveries: Int)
}

enum WorkoutReaderError: Error {
    case noResults
}

class WorkoutReader {
    
    // MARK: Properties
    
    let boxId: String
    let url: URL
    private lazy var parser = FeedParser(URL: self.url)
    
    weak var delegate: WorkoutReaderDelegate?
    
    // MARK: Init
    
    init?(boxId: String, url: String) {
        guard let url = URL(string: url) else {
            return nil
        }
        self.boxId = boxId
        self.url = url
    }
    
    // MARK: Updating
    
    func update() {
        delegate?.reader(self, didBeginUpdating: url)
        parser?.parseAsync(queue: DispatchQueue.global(qos: .userInitiated), result: { (result) in
            if let error = result.error {
                self.delegate?.reader(self, didFailToUpdate: self.url, becauseOf: error)
            } else {
                switch result {
                    
                case .rss(let feed):
                    self.parseResults(feed.items,
                                      success:
                        { (workouts, newDiscoveries) in
                            self.delegate?.reader(self, didLoad: workouts, newDiscoveries: newDiscoveries)
                    }, failure: { (error) in
                        self.delegate?.reader(self, didFailToUpdate: self.url, becauseOf: error)
                    })
                    
                default:()
                }
            }
        })
    }
    
    private func parseResults(_ results: [RSSFeedItem]?,
                              success: (_ workouts: [Workout], _ discoveries: Int) -> Void,
                              failure: (Error) -> Void) {
        guard let results = results else {
            failure(WorkoutReaderError.noResults)
            return
        }
        
        var workouts = [Workout]()
        var discoveryCount: Int = 0
        
        for result in results {
            if let workout = Workout.fromRSSFeedItem(result, boxId: self.boxId) {
                do {
                    let existing = try Workout.makeQuery().filter("guid", .equals, workout.guid).first()
                    if existing == nil { // ignore duplicates
                        try workout.save()
                        discoveryCount += 1
                    }
                    workouts.append(workout)
                } catch {
                    failure(error)
                }
            }
        }
        
        success(workouts, discoveryCount)
    }
}

private extension Workout {
    
    static func fromRSSFeedItem(_ item: RSSFeedItem, boxId: String) -> Workout? {
        guard let guid = item.guid?.value,
            let title = item.title,
            let description = item.description,
            let pubDate = item.pubDate,
            let link = item.link else {
            return nil
        }
        
        return Workout(guid: guid,
                       boxId: boxId,
                       title: title,
                       publishDate: pubDate,
                       rawDescription: description,
                       link: link)
    }
}
