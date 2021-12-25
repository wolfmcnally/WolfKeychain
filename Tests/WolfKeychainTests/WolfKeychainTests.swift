import XCTest
@testable import WolfKeychain
import WolfBase

final class WolfKeychainTests: XCTestCase {
    func testExample() throws {
        let s = "Hello, world!"
        let d = try JSONEncoder().encode(s)
        let s2 = try JSONDecoder().decode(String.self, from: d)
        print(s2)
    }
}
