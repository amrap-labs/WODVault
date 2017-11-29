//
//  WorkoutReaderService.swift
//  WODVaultPackageDescription
//
//  Created by Merrick Sapsford on 29/11/2017.
//

import Foundation

class WorkoutReaderService {
    
    // MARK: Properties
    
    private var readers = [String : WorkoutReader]()
    
    // MARK: Init
    
    init(for urls: [String]) {
        urls.forEach { (url) in
            if let reader = WorkoutReader(url: url) {
                self.readers[url] = reader
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
