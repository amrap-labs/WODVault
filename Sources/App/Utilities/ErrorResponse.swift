//
//  RequestError.swift
//  App
//
//  Created by Merrick Sapsford on 01/12/2017.
//

import Foundation
import HTTP
import JSON

struct ErrorResponse: ResponseRepresentable {
    
    // MARK: Properties
    
    let status: Status
    let message: String?
    
    // MARK: Init
    
    init(status: Status, message: String) {
        self.status = status
        self.message = message
    }
    
    init(status: Status) {
        self.status = status
        self.message = nil
    }
    
    // MARK: ResponseRepresentable
    
    func makeResponse() throws -> Response {
        var json = JSON()
        if let message = self.message {
            try json.set("message", message)
        }
        
        return try Response(status: status, json: json)
    }
}
