import Foundation
import WolfBase

public struct KeyChain {
    public let account: String
    public let key: String
    public let label: String
    public let keychainGroup: String?
    public let syncToCloud: Bool
    
    public init(account: String, key: String, label: String? = nil, keychainGroup: String? = nil, syncToCloud: Bool = false) {
        self.account = account
        self.key = key
        self.label = label ?? key
        self.keychainGroup = keychainGroup
        self.syncToCloud = syncToCloud
    }

    public enum Error: Swift.Error {
        case couldNotCreate(Int)
        case couldNotRead(Int)
        case couldNotUpdate(Int)
        case couldNotDelete(Int)
        case wrongType
    }
    
    private var baseQuery: [NSString: Any] {
        var result: [NSString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecAttrSynchronizable: syncToCloud,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
        ]
        if let keychainGroup = keychainGroup {
            result[kSecAttrAccessGroup] = keychainGroup
        }
        return result
    }

    public func create(data: Data) throws {
        var query = baseQuery
        query[kSecAttrLabel] = label
        query[kSecValueData] = data
        let result = SecItemAdd(query as NSDictionary, nil)
        guard result == errSecSuccess else {
            throw Error.couldNotCreate(Int(result))
        }
    }

    public func create(string: String) throws {
        try create(data: string.utf8Data)
    }

    public func create<T: Codable>(_ object: T) throws {
        let data = try JSONEncoder().encode(object)
        try create(data: data)
    }

    public func read() throws -> Data? {
        var query = baseQuery
        query[kSecReturnAttributes] = true
        query[kSecReturnData] = true

        var value: CFTypeRef?
        let result = SecItemCopyMatching(query as NSDictionary, &value)
        guard result != errSecItemNotFound else {
            return nil
        }
        guard result == errSecSuccess else {
            throw Error.couldNotRead(Int(result))
        }
        guard let dict = value as? [NSString: Any] else {
            throw Error.wrongType
        }
        guard let data = dict[kSecValueData] as? Data else {
            return nil
        }
        return data
    }

    public func read<T: Codable>(_ type: T.Type) throws -> T? {
        guard let data = try read() else {
            return nil
        }
        if type == String.self {
            return data.utf8 as! T?
        } else {
            return try JSONDecoder().decode(type, from: data)
        }
    }

    public func update(data: Data, upsert: Bool = true) throws {
        let query = baseQuery

        var queryNew = baseQuery
        queryNew[kSecValueData] = data

        let result = SecItemUpdate(query as NSDictionary, queryNew as NSDictionary)
        if result == errSecItemNotFound && upsert {
            try create(data: data)
            return
        }

        guard result == errSecSuccess else {
            throw Error.couldNotUpdate(Int(result))
        }
    }

    public func update<T: Codable>(_ object: T, upsert: Bool = true) throws {
        let data = try JSONEncoder().encode(object)
        try update(data: data, upsert: upsert)
    }

    public func delete() throws {
        let query = baseQuery
//        query[kSecReturnAttributes] = true
//        query[kSecReturnData] = true

        let result = SecItemDelete(query as NSDictionary)
        guard result == errSecSuccess else {
            throw Error.couldNotDelete(Int(result))
        }
    }
}