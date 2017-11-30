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
    
    private var readers = [String : WorkoutReader]()
    
    private weak var log: LogProtocol?
    
    // MARK: Init
    
    init(for sources: [WorkoutReaderSource], log: LogProtocol) {
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
        log?.error(error)
    }
}
