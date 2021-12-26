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

    public init(account: String? = nil, key: String? = nil, data: Data? = nil) {
        self.account = account ?? "username"
        self.key = key ?? "password"
        self.data = data
    }

    public convenience init(account: String? = nil, key: String? = nil, string: String) {
        self.init(account: account, key: key, data: string.utf8Data)
    }

    public convenience init<T: Codable>(account: String? = nil, key: String? = nil, object: T) throws {
        let data = try JSONEncoder().encode(object)
        self.init(account: account, key: key, data: data)
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
