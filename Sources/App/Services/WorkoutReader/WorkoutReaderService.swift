//
//  WorkoutReaderService.swift
//  WODVaultPackageDescription
//
//  Created by Merrick Sapsford on 29/11/2017.
//

import Foundation
import Vapor

class WorkoutReaderService {
    
    // MARK: Properties
    
    private static var shared: WorkoutReaderService?

    private var readers = [String : WorkoutReader]()
    private weak var log: LogProtocol?
    
    // MARK: Init
    
    static func shared(for sources: [WorkoutReaderSource], log: LogProtocol) -> WorkoutReaderService {
        if let shared = WorkoutReaderService.shared {
            return shared
        }
        let service = WorkoutReaderService(for: sources, log: log)
        shared = service
        return service
    }
    
    private init(for sources: [WorkoutReaderSource], log: LogProtocol) {
        self.log = log
        
        for source in sources {
            if let reader = WorkoutReader(boxId: source.boxId, url: source.url) {
                reader.delegate = self
                self.readers[source.url] = reader
            }
        }
    }
    
    // MARK: Readers
    
    func reader(for url: String) -> WorkoutReader? {
        return readers[url]
    }
    
    func updateAll() {
        readers.values.forEach { (reader) in
            reader.update()
        }
    }
}

extension WorkoutReaderService: WorkoutReaderDelegate {
    
    func reader(_ reader: WorkoutReader, didBeginUpdating feedUrl: URL) {
        log?.info("WRS - Updating Feed (\(feedUrl.absoluteString))")
    }
    
    func reader(_ reader: WorkoutReader, didFailToUpdate feedUrl: URL, becauseOf error: Error) {
        log?.error("WRS - Feed Errored (\(feedUrl.absoluteString)):")
        log?.error("      \(error)")
    }
    
    func reader(_ reader: WorkoutReader, didLoad workouts: [Workout], newDiscoveries: Int) {
        log?.info("WRS - Updated Feed (\(reader.url.absoluteString)):")
        log?.info("      New Discoveries: \(newDiscoveries)")
    }
}
