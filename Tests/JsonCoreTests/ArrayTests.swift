import XCTest

@testable import JsonCore

public final class ArrayTests: XCTestCase {
  func testParseEmptyArray() throws {
    let result = try JsonCore.parse("[]")
    guard let token = result.token as? ArrayToken else {
      XCTFail("Token is not an ArrayToken")
      return
    }
    XCTAssertEqual(token.values.count, 0)
  }

  func testParseNumberArray() throws {
    let result = try JsonCore.parse("[1, 2, 3]")
    guard let token = result.token as? ArrayToken else {
      XCTFail("Token is not an ArrayToken")
      return
    }
    XCTAssertEqual(token.values.count, 3)
    let numbers = token.values.compactMap { ($0 as? NumberToken)?.value }
    XCTAssertEqual(numbers, [1, 2, 3])
  }

  func testParseNestedArray() throws {
    let result = try JsonCore.parse("[[1], [2, 3]]")
    guard let token = result.token as? ArrayToken else {
      XCTFail("Token is not an ArrayToken")
      return
    }
    XCTAssertEqual(token.values.count, 2)
    guard let first = token.values[0] as? ArrayToken,
      let second = token.values[1] as? ArrayToken
    else {
      XCTFail("Nested arrays not parsed correctly")
      return
    }
    let firstNumbers = first.values.compactMap { ($0 as? NumberToken)?.value }
    let secondNumbers = second.values.compactMap { ($0 as? NumberToken)?.value }
    XCTAssertEqual(firstNumbers, [1])
    XCTAssertEqual(secondNumbers, [2, 3])
  }
}
