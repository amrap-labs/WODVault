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
                    self.parseResults(feed.items, completion: { (workout) in
                        
                    })
                    
                default:()
                }
            }
        })
    }
    
    private func parseResults(_ results: [RSSFeedItem]?,
                              completion: ([Workout]?) -> Void) {
        guard let results = results else {
            completion(nil)
            return
        }
        
        for result in results {
            if let workout = Workout.fromRSSFeedItem(result, boxId: self.boxId) {
                do {
                    let existing = try Workout.makeQuery().filter("guid", .equals, workout.guid).first()
                    if existing == nil { // ignore duplicates
                        try workout.save()
                    }
                } catch {
                    // TODO - Log
                }
            }
        }
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
