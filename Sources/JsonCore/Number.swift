import Foundation

public struct NumberToken: Token {
  public let type: JsonType
  public let value: Double?
}
public func parseNumber(_ expression: String, delimiters: NSRegularExpression? = nil) throws
  -> JsonCore.JsonParseResult
{
  enum Mode {
    case characteristic, characteristicDigit, decimalPoint, end, exponent, exponentDigits,
      exponentFirstDigit, exponentSign, mantissa, scanning
  }

  var mode: Mode = .scanning
  var pos = 0
  var valueAsString = ""
  var value: Double? = nil

  while pos < expression.count && mode != .end {
    let ch = expression[expression.index(expression.startIndex, offsetBy: pos)]
    switch mode {
    case .scanning:
      if ch.isWhitespace {
        pos += 1
      } else if ch == "-" {
        valueAsString = "-"
        pos += 1
        mode = .characteristic
      } else {
        mode = .characteristic
      }
    case .characteristic:
      if ch == "0" {
        valueAsString += "0"
        pos += 1
        mode = .decimalPoint
      } else if ch.isNumber && ch != "0" {
        valueAsString += String(ch)
        pos += 1
        mode = .characteristicDigit
      } else {
        throw SyntaxError("Expected digit, actual '\(ch)'")
      }
    case .characteristicDigit:
      if ch.isNumber {
        valueAsString += String(ch)
        pos += 1
      } else if delimiters?.firstMatch(
        in: String(ch),
        options: [],
        range: NSRange(location: 0, length: String(ch).utf16.count)) != nil
      {
        mode = .end
      } else {
        mode = .decimalPoint
      }
    case .decimalPoint:
      if ch == "." {
        valueAsString += "."
        pos += 1
        mode = .mantissa
      } else if delimiters?.firstMatch(
        in: String(ch),
        options: [],
        range: NSRange(location: 0, length: String(ch).utf16.count)) != nil
      {
        mode = .end
      } else {
        mode = .exponent
      }
    case .mantissa:
      if ch.isNumber {
        valueAsString += String(ch)
        pos += 1
      } else if ch == "e" || ch == "E" {
        mode = .exponent
      } else if delimiters?.firstMatch(
        in: String(ch),
        options: [],
        range: NSRange(location: 0, length: String(ch).utf16.count)) != nil
      {
        mode = .end
      } else {
        throw SyntaxError("unexpected character '\(ch)'")
      }
    case .exponent:
      if ch == "e" || ch == "E" {
        valueAsString += "e"
        pos += 1
        mode = .exponentSign
      } else {
        throw SyntaxError("expected 'e' or 'E', actual '\(ch)'")
      }
    case .exponentSign:
      if ch == "+" || ch == "-" {
        valueAsString += String(ch)
        pos += 1
        mode = .exponentFirstDigit
      } else {
        mode = .exponentFirstDigit
      }
    case .exponentFirstDigit:
      if ch.isNumber {
        valueAsString += String(ch)
        pos += 1
        mode = .exponentDigits
      } else {
        throw SyntaxError("expected digit, actual '\(ch)'")
      }
    case .exponentDigits:
      if ch.isNumber {
        valueAsString += String(ch)
        pos += 1
      } else if delimiters?.firstMatch(
        in: String(ch),
        options: [],
        range: NSRange(location: 0, length: String(ch).utf16.count)) != nil
      {
        mode = .end
      } else {
        throw SyntaxError("expected digit, actual '\(ch)'")
      }
    case .end:
      break
    }
  }

  switch mode {
  case .characteristic, .exponentFirstDigit, .exponentSign:
    throw SyntaxError("incomplete expression, mode \(mode)")
  default:
    value = Double(valueAsString)
  }

  let token = NumberToken(type: .number, value: value)

  return JsonCore.JsonParseResult(skip: pos, token: token)
}
