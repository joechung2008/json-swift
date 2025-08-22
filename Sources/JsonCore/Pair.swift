import Foundation

public struct PairToken: Token {
  public let type: JsonType
  public let key: StringToken?
  public let value: Token?
}
public func parsePair(_ expression: String) throws -> JsonCore.JsonParseResult {
  enum Mode {
    case colon, end, scanning, string, value
  }

  var mode: Mode = .scanning
  var pos = 0
  var key: StringToken? = nil
  var valueToken: Token? = nil
  let delimiters: NSRegularExpression = try NSRegularExpression(
    pattern: #"[ \n\r\t\},]"#, options: [])

  while pos < expression.count && mode != .end {
    let ch = expression[expression.index(expression.startIndex, offsetBy: pos)]
    switch mode {
    case .scanning:
      if ch.isWhitespace {
        pos += 1
      } else {
        mode = .string
      }
    case .string:
      let slice = String(
        expression.suffix(from: expression.index(expression.startIndex, offsetBy: pos)))
      let stringResult = try parseString(slice)
      key = stringResult.token as? StringToken
      pos += stringResult.skip
      mode = .colon
    case .colon:
      if ch.isWhitespace {
        pos += 1
      } else if ch == ":" {
        pos += 1
        mode = .value
      } else {
        throw SyntaxError("expected ':', actual '\(ch)'")
      }
    case .value:
      let slice = String(
        expression.suffix(from: expression.index(expression.startIndex, offsetBy: pos)))
      let valueResult = try parseValue(slice, delimiters: delimiters)
      valueToken = valueResult.token
      pos += valueResult.skip
      mode = .end
    case .end:
      break
    }
  }

  if mode != .end {
    throw SyntaxError("incomplete expression, mode \(mode)")
  }

  let token = PairToken(type: .pair, key: key, value: valueToken)

  return JsonCore.JsonParseResult(skip: pos, token: token)
}
