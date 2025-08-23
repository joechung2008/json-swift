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

  func testParseEscapedQuote() throws {
    let result = try JsonCore.parse("\"foo\\\"bar\"")
    guard let token = result.token as? StringToken else {
      XCTFail("Token is not a StringToken")
      return
    }
    XCTAssertEqual(token.value, "foo\"bar")
  }

  func testParseEscapedBackslash() throws {
    let result = try JsonCore.parse("\"foo\\\\bar\"")
    guard let token = result.token as? StringToken else {
      XCTFail("Token is not a StringToken")
      return
    }
    XCTAssertEqual(token.value, "foo\\bar")
  }

  func testParseEscapedSlash() throws {
    let result = try JsonCore.parse("\"foo\\/bar\"")
    guard let token = result.token as? StringToken else {
      XCTFail("Token is not a StringToken")
      return
    }
    XCTAssertEqual(token.value, "foo/bar")
  }

  func testParseEscapedBackspace() throws {
    let result = try JsonCore.parse("\"foo\\bbar\"")
    guard let token = result.token as? StringToken else {
      XCTFail("Token is not a StringToken")
      return
    }
    XCTAssertEqual(token.value, "foo\u{8}bar")
  }

  func testParseEscapedFormfeed() throws {
    let result = try JsonCore.parse("\"foo\\fbar\"")
    guard let token = result.token as? StringToken else {
      XCTFail("Token is not a StringToken")
      return
    }
    XCTAssertEqual(token.value, "foo\u{c}bar")
  }

  func testParseEscapedCarriageReturn() throws {
    let result = try JsonCore.parse("\"foo\\rbar\"")
    guard let token = result.token as? StringToken else {
      XCTFail("Token is not a StringToken")
      return
    }
    XCTAssertEqual(token.value, "foo\rbar")
  }

  func testParseEscapedTab() throws {
    let result = try JsonCore.parse("\"foo\\tbar\"")
    guard let token = result.token as? StringToken else {
      XCTFail("Token is not a StringToken")
      return
    }
    XCTAssertEqual(token.value, "foo\tbar")
  }

  func testParseUnicode() throws {
    let result = try JsonCore.parse("\"foo\\u0041bar\"")
    guard let token = result.token as? StringToken else {
      XCTFail("Token is not a StringToken")
      return
    }
    XCTAssertEqual(token.value, "fooAbar")
  }

  func testParseMultipleEscapes() throws {
    let result = try JsonCore.parse("\"\\\"\\\\\\/\\b\\f\\n\\r\\t\\u0041\"")
    guard let token = result.token as? StringToken else {
      XCTFail("Token is not a StringToken")
      return
    }
    XCTAssertEqual(token.value, "\"\\/\u{8}\u{c}\n\r\tA")
  }

  func testParseInvalidEscape() throws {
    XCTAssertThrowsError(try JsonCore.parse("\"foo\\xbar\""))
  }

  func testParseIncompleteUnicode() throws {
    XCTAssertThrowsError(try JsonCore.parse("\"foo\\u12\""))
  }

  func testParseInvalidUnicode() throws {
    XCTAssertThrowsError(try JsonCore.parse("\"foo\\uZZZZ\""))
  }

  func testParseUnterminatedString() throws {
    XCTAssertThrowsError(try JsonCore.parse("\"foo"))
  }

  func testParseStringWithNewline() throws {
    XCTAssertThrowsError(try JsonCore.parse("\"\nfoo\""))
  }
}
