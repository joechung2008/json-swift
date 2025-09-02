import XCTest

@testable import JsonCore

public final class NumberTests: XCTestCase {
  func testParseNegativeExponent() throws {
    let result = try parseNumber("1.23e-14")
    guard let token = result.token as? NumberToken else {
      XCTFail("Token is not a NumberToken")
      return
    }
    guard let value = token.value else {
      XCTFail("Token value is nil")
      return
    }
    XCTAssertEqual(value, 1.23e-14, accuracy: 1e-20, "Exponent parsing failed")
  }

  func testParsePositiveInteger() throws {
    let result = try parseNumber("42")
    guard let token = result.token as? NumberToken else {
      XCTFail("Token is not a NumberToken")
      return
    }
    XCTAssertEqual(token.value, 42)
  }

  func testParseNegativeInteger() throws {
    let result = try parseNumber("-17")
    guard let token = result.token as? NumberToken else {
      XCTFail("Token is not a NumberToken")
      return
    }
    XCTAssertEqual(token.value, -17)
  }

  func testParsePositiveFloat() throws {
    let result = try parseNumber("3.1415")
    guard let token = result.token as? NumberToken else {
      XCTFail("Token is not a NumberToken")
      return
    }
    guard let value = token.value else {
      XCTFail("Token value is nil")
      return
    }
    XCTAssertEqual(value, 3.1415, accuracy: 1e-10)
  }

  func testParseNegativeFloat() throws {
    let result = try parseNumber("-0.001")
    guard let token = result.token as? NumberToken else {
      XCTFail("Token is not a NumberToken")
      return
    }
    guard let value = token.value else {
      XCTFail("Token value is nil")
      return
    }
    XCTAssertEqual(value, -0.001, accuracy: 1e-10)
  }

  func testParsePositiveExponent() throws {
    let result = try parseNumber("2e10")
    guard let token = result.token as? NumberToken else {
      XCTFail("Token is not a NumberToken")
      return
    }
    guard let value = token.value else {
      XCTFail("Token value is nil")
      return
    }
    XCTAssertEqual(value, 2e10, accuracy: 1e-5)
  }

  func testParseNegativeNumberWithExponent() throws {
    let result = try parseNumber("-5.67e-3")
    guard let token = result.token as? NumberToken else {
      XCTFail("Token is not a NumberToken")
      return
    }
    guard let value = token.value else {
      XCTFail("Token value is nil")
      return
    }
    XCTAssertEqual(value, -5.67e-3, accuracy: 1e-10)
  }

  func testParseZero() throws {
    let result = try parseNumber("0")
    guard let token = result.token as? NumberToken else {
      XCTFail("Token is not a NumberToken")
      return
    }
    XCTAssertEqual(token.value, 0)
  }

  func testParseLargeNumber() throws {
    let result = try parseNumber("12345678901234567890")
    guard let token = result.token as? NumberToken else {
      XCTFail("Token is not a NumberToken")
      return
    }
    XCTAssertEqual(token.value, 12_345_678_901_234_567_890)
  }

  func testParseSmallNumber() throws {
    let result = try parseNumber("0.000000000123")
    guard let token = result.token as? NumberToken else {
      XCTFail("Token is not a NumberToken")
      return
    }
    guard let value = token.value else {
      XCTFail("Token value is nil")
      return
    }
    XCTAssertEqual(value, 0.000000000123, accuracy: 1e-15)
  }

  func testParseInvalidNumberMultipleDots() throws {
    XCTAssertThrowsError(try parseNumber("1.2.3"))
  }

  func testParseInvalidNumberLetters() throws {
    XCTAssertThrowsError(try parseNumber("12abc"))
  }

  func testParseInvalidLeadingZero() throws {
    XCTAssertThrowsError(try parseNumber("0123"))
  }

  func testParseInvalidPlusNumber() throws {
    XCTAssertThrowsError(try JsonCore.parse("+3"))
  }
}
