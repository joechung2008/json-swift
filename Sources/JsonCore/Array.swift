import Foundation

public struct ArrayToken: Token {
  public let type: JsonType
  public let values: [Token]
}
public func parseArray(_ expression: String) throws -> JsonCore.JsonParseResult {
  enum Mode {
    case comma, elements, end, scanning
  }

  var mode: Mode = .scanning
  var pos = 0
  var values: [Token] = []
  let delimiters: NSRegularExpression = try NSRegularExpression(
    pattern: #"[ \n\r\t\],]"#, options: [])

  while pos < expression.count && mode != .end {
    let ch = expression[expression.index(expression.startIndex, offsetBy: pos)]
    switch mode {
    case .scanning:
      if ch.isWhitespace {
        pos += 1
      } else if ch == "[" {
        pos += 1
        mode = .elements
      } else {
        throw SyntaxError("expected '[', actual '\(ch)'")
      }
    case .elements:
      if ch.isWhitespace {
        pos += 1
      } else if ch == "]" {
        if values.count > 0 {
          throw SyntaxError("unexpected ','")
        }
        pos += 1
        mode = .end
      } else {
        let slice = String(
          expression.suffix(
            from: expression.index(expression.startIndex, offsetBy: pos)))
        let value = try parseValue(slice, delimiters: delimiters)
        if let tokenValue = value.token {
          values.append(tokenValue)
        }
        pos += value.skip
        mode = .comma
      }
    case .comma:
      if ch.isWhitespace {
        pos += 1
      } else if ch == "]" {
        pos += 1
        mode = .end
      } else if ch == "," {
        pos += 1
        mode = .elements
      } else {
        throw SyntaxError("expected ',', actual '\(ch)'")
      }
    case .end:
      break
    }
  }

  if mode != .end {
    throw SyntaxError("incomplete expression, mode \(mode)")
  }

  let arrayToken = ArrayToken(type: .array, values: values)

  return JsonCore.JsonParseResult(skip: pos, token: arrayToken)
}
