//
//  File.swift
//  
//
//  Created by Wolf McNally on 12/25/21.
//

import Foundation

public enum KeychainError: Error {
    case couldNotCreate(Int)
    case couldNotRead(Int)
    case couldNotUpdate(Int)
    case couldNotDelete(Int)
    case wrongType
}
