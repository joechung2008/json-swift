import XCTest

@testable import JsonCore

public final class ObjectTests: XCTestCase {
  func testParseEmptyObject() throws {
    let result = try JsonCore.parse("{}")
    guard let token = result.token as? ObjectToken else {
      XCTFail("Token is not an ObjectToken")
      return
    }
    XCTAssertEqual(token.members.count, 0)
  }

  func testParseSimpleObject() throws {
    let result = try JsonCore.parse("{\"a\": 1, \"b\": 2}")
    guard let token = result.token as? ObjectToken else {
      XCTFail("Token is not an ObjectToken")
      return
    }
    XCTAssertEqual(token.members.count, 2)
    let keys = token.members.compactMap { $0.key?.value }
    XCTAssertEqual(Set(keys), Set(["a", "b"]))
    let values = token.members.compactMap { ($0.value as? NumberToken)?.value }
    XCTAssertEqual(Set(values), Set([1, 2]))
  }

  func testParseNestedObject() throws {
    let result = try JsonCore.parse("{\"outer\": {\"inner\": 42}}")
    guard let token = result.token as? ObjectToken else {
      XCTFail("Token is not an ObjectToken")
      return
    }
    XCTAssertEqual(token.members.count, 1)
    guard let innerObject = token.members[0].value as? ObjectToken else {
      XCTFail("Nested object not parsed correctly")
      return
    }
    XCTAssertEqual(innerObject.members.count, 1)
    let key = innerObject.members[0].key?.value
    let value = (innerObject.members[0].value as? NumberToken)?.value
    XCTAssertEqual(key, "inner")
    XCTAssertEqual(value, 42)
  }
}
