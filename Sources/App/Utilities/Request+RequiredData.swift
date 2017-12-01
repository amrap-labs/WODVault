//
//  Request+RequiredData.swift
//  App
//
//  Created by Merrick Sapsford on 01/12/2017.
//

import Foundation
import Vapor

extension Request {
    
    func isMissingData(for keys: [String]) -> ResponseRepresentable? {
        var missingKeys = [String]()
        for key in keys {
            if data[key] == nil {
                missingKeys.append(key)
            }
        }
        
        if missingKeys.count > 0 {
            var errorString = ""
            for key in missingKeys {
                if errorString.count != 0 {
                    errorString += ", "
                }
                errorString += key
            }
            errorString += " \(missingKeys.count == 1 ? "is" : "are") required"
            
            return ErrorResponse(status: .badRequest, message: errorString)
            
        } else {
            return nil
        }
    }
}
