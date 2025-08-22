public struct StringToken: Token {
  public let type: JsonType
  public let value: String?
}
public func parseString(_ expression: String) throws -> JsonCore.JsonParseResult {
  enum Mode {
    case char, end, escapedChar, scanning, unicode
  }

  var mode: Mode = .scanning
  var pos = 0
  var value = ""

  while pos < expression.count && mode != .end {
    let ch = expression[expression.index(expression.startIndex, offsetBy: pos)]
    switch mode {
    case .scanning:
      if ch.isWhitespace {
        pos += 1
      } else if ch == "\"" {
        value = ""
        pos += 1
        mode = .char
      } else {
        throw SyntaxError("expected '\"', actual '\(ch)'")
      }
    case .char:
      if ch == "\\" {
        pos += 1
        mode = .escapedChar
      } else if ch == "\"" {
        pos += 1
        mode = .end
      } else if ch != "\n" && ch != "\r" {
        value += String(ch)
        pos += 1
      } else {
        throw SyntaxError("unexpected character '\(ch)'")
      }
    case .escapedChar:
      if ch == "\"" || ch == "\\" || ch == "/" {
        value += String(ch)
        pos += 1
        mode = .char
      } else if ch == "b" {
        value += "\u{8}"
        pos += 1
        mode = .char
      } else if ch == "f" {
        value += "\u{c}"
        pos += 1
        mode = .char
      } else if ch == "n" {
        value += "\n"
        pos += 1
        mode = .char
      } else if ch == "r" {
        value += "\r"
        pos += 1
        mode = .char
      } else if ch == "t" {
        value += "\t"
        pos += 1
        mode = .char
      } else if ch == "u" {
        pos += 1
        mode = .unicode
      } else {
        throw SyntaxError("unexpected escape character '\(ch)'")
      }
    case .unicode:
      let end = min(pos + 4, expression.count)
      let slice = String(
        expression[
          expression.index(
            expression.startIndex, offsetBy: pos)..<expression.index(
              expression.startIndex, offsetBy: end)])
      if slice.count < 4 {
        throw SyntaxError("incomplete Unicode code '\(slice)'")
      }
      if let hex = Int(slice, radix: 16), let scalar = UnicodeScalar(hex) {
        value += String(scalar)
      } else {
        throw SyntaxError("unexpected Unicode code '\(slice)'")
      }
      pos += 4
      mode = .char
    case .end:
      break
    }
  }

  if mode != .end {
    throw SyntaxError("incomplete string, mode \(mode)")
  }

  let token = StringToken(type: .string, value: value)

  return JsonCore.JsonParseResult(skip: pos, token: token)
}
