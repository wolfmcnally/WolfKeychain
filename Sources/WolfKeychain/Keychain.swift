//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import WolfBase

public protocol Keychain {
    var account: String { get }
    var key: String { get }
    
    func create(data: Data) throws
    func read() throws -> Data?
    func update(data: Data, upsert: Bool) throws
    func delete() throws
}

extension Keychain {
    public func create(string: String) throws {
        try create(data: string.utf8Data)
    }

    public func create<T: Codable>(_ object: T) throws {
        let data = try JSONEncoder().encode(object)
        try create(data: data)
    }

    public func read<T: Codable>(_ type: T.Type) throws -> T? {
        guard let data = try read() else {
            return nil
        }
        return try JSONDecoder().decode(type, from: data)
    }

    public func update<T: Codable>(_ object: T, upsert: Bool = true) throws {
        let data = try JSONEncoder().encode(object)
        try update(data: data, upsert: upsert)
    }
}

