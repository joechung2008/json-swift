import XCTest

@testable import JsonCore

public final class PairTests: XCTestCase {
  func testParseSimplePair() throws {
    let result = try JsonCore.parse("{\"key\": \"value\"}")
    guard let object = result.token as? ObjectToken else {
      XCTFail("Token is not an ObjectToken")
      return
    }
    XCTAssertEqual(object.members.count, 1)
    let pair = object.members[0]
    XCTAssertEqual(pair.key?.value, "key")
    XCTAssertEqual((pair.value as? StringToken)?.value, "value")
  }

  func testParseNumberPair() throws {
    let result = try JsonCore.parse("{\"num\": 42}")
    guard let object = result.token as? ObjectToken else {
      XCTFail("Token is not an ObjectToken")
      return
    }
    XCTAssertEqual(object.members.count, 1)
    let pair = object.members[0]
    XCTAssertEqual(pair.key?.value, "num")
    XCTAssertEqual((pair.value as? NumberToken)?.value, 42)
  }

  func testParseMultiplePairs() throws {
    let result = try JsonCore.parse("{\"a\": 1, \"b\": \"two\"}")
    guard let object = result.token as? ObjectToken else {
      XCTFail("Token is not an ObjectToken")
      return
    }
    XCTAssertEqual(object.members.count, 2)
    let keys = object.members.compactMap { $0.key?.value }
    XCTAssertEqual(Set(keys), Set(["a", "b"]))
    let aValue = (object.members.first { $0.key?.value == "a" }?.value as? NumberToken)?.value
    let bValue = (object.members.first { $0.key?.value == "b" }?.value as? StringToken)?.value
    XCTAssertEqual(aValue, 1)
    XCTAssertEqual(bValue, "two")
  }
}
