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
        let object = config.object
        guard let boxId = object?[Keys.boxId]?.string,
            let url = object?[Keys.url]?.string else {
            return nil
        }
        
        self.boxId = boxId
        self.url = url
    }
}
