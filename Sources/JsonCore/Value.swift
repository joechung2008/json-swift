import Foundation

public struct FalseToken: Token {
  public let type: JsonType
  public let value: Bool
}
public struct NullToken: Token {
  public let type: JsonType
  public let value: Any?
}
public struct TrueToken: Token {
  public let type: JsonType
  public let value: Bool
}
public func parseValue(_ expression: String, delimiters: NSRegularExpression? = nil) throws
  -> JsonCore.JsonParseResult
{
  enum Mode {
    case array, end, falseType, null, number, object, string, scanning, trueType
  }
  var mode: Mode = .scanning
  var pos = 0
  var token: Token? = nil

  while pos < expression.count && mode != .end {
    let ch = expression[expression.index(expression.startIndex, offsetBy: pos)]
    switch mode {
    case .scanning:
      if ch.isWhitespace {
        pos += 1
      } else if ch == "[" {
        mode = .array
      } else if ch == "f" {
        mode = .falseType
      } else if ch == "n" {
        mode = .null
      } else if ch.isNumber || ch == "-" {
        mode = .number
      } else if ch == "{" {
        mode = .object
      } else if ch == "\"" {
        mode = .string
      } else if ch == "t" {
        mode = .trueType
      } else if delimiters?.firstMatch(
        in: String(ch),
        options: [],
        range: NSRange(location: 0, length: String(ch).utf16.count)) != nil
      {
        mode = .end
      } else {
        throw SyntaxError(
          "expected array, false, null, number, object, string, or true, actual '\(ch)'"
        )
      }
    case .array:
      let slice = String(
        expression.suffix(from: expression.index(expression.startIndex, offsetBy: pos)))
      let arrayResult = try parseArray(slice)
      token = arrayResult.token
      pos += arrayResult.skip
      mode = .end
    case .falseType:
      let slice = String(
        expression.suffix(
          from: expression.index(
            expression.startIndex, offsetBy: pos, limitedBy: expression.endIndex)
            ?? expression.endIndex))
      if slice.hasPrefix("false") {
        token = FalseToken(type: .falseType, value: false)
        pos += 5
        mode = .end
      } else {
        throw SyntaxError("expected false, actual \(slice)")
      }
    case .null:
      let slice = String(
        expression.suffix(
          from: expression.index(
            expression.startIndex, offsetBy: pos, limitedBy: expression.endIndex)
            ?? expression.endIndex))
      if slice.hasPrefix("null") {
        token = NullToken(type: .null, value: nil)
        pos += 4
        mode = .end
      } else {
        throw SyntaxError("expected null, actual \(slice)")
      }
    case .number:
      let slice = String(
        expression.suffix(from: expression.index(expression.startIndex, offsetBy: pos)))
      let numberResult = try parseNumber(slice, delimiters: delimiters)
      token = numberResult.token
      pos += numberResult.skip
      mode = .end
    case .object:
      let slice = String(
        expression.suffix(from: expression.index(expression.startIndex, offsetBy: pos)))
      let objectResult = try parseObject(slice)
      token = objectResult.token
      pos += objectResult.skip
      mode = .end
    case .string:
      let slice = String(
        expression.suffix(from: expression.index(expression.startIndex, offsetBy: pos)))
      let stringResult = try parseString(slice)
      token = stringResult.token
      pos += stringResult.skip
      mode = .end
    case .trueType:
      let slice = String(
        expression.suffix(
          from: expression.index(
            expression.startIndex, offsetBy: pos, limitedBy: expression.endIndex)
            ?? expression.endIndex))
      if slice.hasPrefix("true") {
        token = TrueToken(type: .trueType, value: true)
        pos += 4
        mode = .end
      } else {
        throw SyntaxError("expected true, actual \(slice)")
      }
    case .end:
      break
    }
  }

  if token == nil {
    throw SyntaxError("value cannot be empty")
  }

  return JsonCore.JsonParseResult(skip: pos, token: token)
}
