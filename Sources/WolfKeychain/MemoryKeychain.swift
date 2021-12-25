//
//  File.swift
//  
//
//  Created by Wolf McNally on 12/25/21.
//

import Foundation

public final class MemoryKeychain: Keychain {
    public let account: String
    public let key: String
    public var data: Data?

    public init(account: String, key: String) {
        self.account = account
        self.key = key
    }
    
    public func create(data: Data) throws {
        guard self.data == nil else {
            throw KeychainError.couldNotCreate(1)
        }
        self.data = data
    }
    
    public func read() throws -> Data? {
        self.data
    }
    
    public func update(data: Data, upsert: Bool) throws {
        self.data = data
    }
    
    public func delete() throws {
        self.data = nil
    }
}
