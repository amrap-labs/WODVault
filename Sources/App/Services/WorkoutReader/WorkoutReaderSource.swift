//
//  WorkoutReaderSource.swift
//  WODVaultPackageDescription
//
//  Created by Merrick Sapsford on 30/11/2017.
//

import Foundation
import Vapor

struct WorkoutReaderSource {
    
    private struct Keys {
        static let boxId = "box_id"
        static let url = "url"
    }
    
    let boxId: String
    let url: String
    
    init?(config: Config) {
        guard let boxId = config[Keys.boxId]?.string,
            let url = config[Keys.url]?.string else {
            return nil
        }
        
        self.boxId = boxId
        self.url = url
    }
}
