//
//  WorkoutReader.swift
//  WODVaultPackageDescription
//
//  Created by Merrick Sapsford on 29/11/2017.
//

import Foundation

class WorkoutReader {
    
    // MARK: Properties
    
    let url: URL
    
    // MARK: Init
    
    init?(url: String) {
        guard let url = URL(string: url) else {
            return nil
        }
        self.url = url
    }
    
    // MARK: Updating
    
    func update() {
        
    }
}
