import XCTest

@testable import JsonCore

public final class StringTests: XCTestCase {
  func testParseEmptyString() throws {
    let result = try JsonCore.parse("\"\"")
    guard let token = result.token as? StringToken else {
      XCTFail("Token is not a StringToken")
      return
    }
    XCTAssertEqual(token.value, "")
  }

  func testParseNormalString() throws {
    let result = try JsonCore.parse("\"hello\"")
    guard let token = result.token as? StringToken else {
      XCTFail("Token is not a StringToken")
      return
    }
    XCTAssertEqual(token.value, "hello")
  }

  func testParseEscapedString() throws {
    let result = try JsonCore.parse("\"line\\nbreak\"")
    guard let token = result.token as? StringToken else {
      XCTFail("Token is not a StringToken")
      return
    }
    XCTAssertEqual(token.value, "line\nbreak")
  }
}
