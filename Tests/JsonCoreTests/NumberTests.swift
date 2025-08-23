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
}
