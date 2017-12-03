//
//  Droplet+Jobs.swift
//  WODVaultPackageDescription
//
//  Created by Merrick Sapsford on 03/12/2017.
//

import Vapor
import Jobs

extension Droplet {
    
    func setupJobs() {
        
        // Workout Reader job
        let feeds = (config["sources"]?.array ?? []).flatMap({ WorkoutReaderSource(config: $0) })
        Jobs.add(interval: .seconds(900)) {
            let readerService = WorkoutReaderService.shared(for: feeds, log: self.log)
            readerService.updateAll()
        }
    }
}
