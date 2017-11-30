//
//  WorkoutReader.swift
//  WODVaultPackageDescription
//
//  Created by Merrick Sapsford on 29/11/2017.
//

import Foundation
import FeedKit

class WorkoutReader {
    
    // MARK: Properties
    
    let url: URL
    private lazy var parser = FeedParser(URL: self.url)
    
    // MARK: Init
    
    init?(url: String) {
        guard let url = URL(string: url) else {
            return nil
        }
        self.url = url
    }
    
    // MARK: Updating
    
    func update() {
        print("UPDATING Feed: \(url)")
        parser?.parseAsync(queue: DispatchQueue.global(qos: .userInitiated), result: { (result) in
            if let error = result.error {
                
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
            if let workout = Workout.fromRSSFeedItem(result) {
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
    
    static func fromRSSFeedItem(_ item: RSSFeedItem) -> Workout? {
        guard let guid = item.guid?.value,
            let title = item.title,
            let description = item.description,
            let pubDate = item.pubDate,
            let link = item.link else {
            return nil
        }
        
        return Workout(guid: guid,
                       title: title,
                       publishDate: pubDate,
                       rawDescription: description,
                       link: link)
    }
}
