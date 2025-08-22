import Foundation

public struct JsonCore {
  public struct JsonParseResult {
    public let skip: Int
    public let token: Token?
  }
  public static func parse(_ expression: String) throws -> JsonParseResult {
    enum Mode {
      case end
      case scanning
      case value
    }

    guard type(of: expression) == String.self else {
      throw NSError(
        domain: "JsonCore", code: 1,
        userInfo: [NSLocalizedDescriptionKey: "expression expected string"])
    }

    var mode: Mode = .scanning
    var pos = 0
    var token: Token? = nil
    let delimiters: NSRegularExpression = try NSRegularExpression(
      pattern: #"[ \n\r\t]"#, options: [])

    while pos < expression.count && mode != .end {
      let ch = expression[expression.index(expression.startIndex, offsetBy: pos)]

      switch mode {
      case .scanning:
        if ch.isWhitespace {
          pos += 1
        } else {
          mode = .value
        }
      case .value:
        let slice = String(
          expression.suffix(from: expression.index(expression.startIndex, offsetBy: pos)))
        let value = try parseValue(slice, delimiters: delimiters)
        token = value.token
        pos += value.skip
        mode = .end
      case .end:
        break
      }
    }

    return JsonParseResult(skip: pos, token: token)
  }
}
