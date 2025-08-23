import XCTest

@testable import JsonCore

public final class ValueTests: XCTestCase {
  func testParseNumberValue() throws {
    let result = try JsonCore.parse("123")
    XCTAssertTrue(result.token is NumberToken)
  }

  func testParseStringValue() throws {
    let result = try JsonCore.parse("\"abc\"")
    XCTAssertTrue(result.token is StringToken)
  }

  func testParseArrayValue() throws {
    let result = try JsonCore.parse("[1,2]")
    XCTAssertTrue(result.token is ArrayToken)
  }

  func testParseObjectValue() throws {
    let result = try JsonCore.parse("{\"x\":1}")
    XCTAssertTrue(result.token is ObjectToken)
  }

  func testParseTrueValue() throws {
    let result = try JsonCore.parse("true")
    XCTAssertTrue(result.token is TrueToken)
  }

  func testParseFalseValue() throws {
    let result = try JsonCore.parse("false")
    XCTAssertTrue(result.token is FalseToken)
  }

  func testParseNullValue() throws {
    let result = try JsonCore.parse("null")
    XCTAssertTrue(result.token is NullToken)
  }
}
