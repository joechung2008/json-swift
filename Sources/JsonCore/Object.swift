public struct ObjectToken: Token {
  public let type: JsonType
  public let members: [PairToken]
}
public func parseObject(_ expression: String) throws -> JsonCore.JsonParseResult {
  enum Mode {
    case delimiter, end, pair, scanning
  }
  var mode: Mode = .scanning
  var pos = 0
  var members: [PairToken] = []

  while pos < expression.count && mode != .end {
    let ch = expression[expression.index(expression.startIndex, offsetBy: pos)]
    switch mode {
    case .scanning:
      if ch.isWhitespace {
        pos += 1
      } else if ch == "{" {
        pos += 1
        mode = .pair
      } else {
        throw SyntaxError("expected '{', actual '\(ch)'")
      }
    case .pair:
      if ch.isWhitespace {
        pos += 1
      } else if ch == "}" {
        if members.count > 0 {
          throw SyntaxError("unexpected ','")
        }
        pos += 1
        mode = .end
      } else {
        let slice = String(
          expression.suffix(
            from: expression.index(expression.startIndex, offsetBy: pos)))
        let pairResult = try parsePair(slice)
        if let pairToken = pairResult.token as? PairToken {
          members.append(pairToken)
        }
        pos += pairResult.skip
        mode = .delimiter
      }
    case .delimiter:
      if ch.isWhitespace {
        pos += 1
      } else if ch == "," {
        pos += 1
        mode = .pair
      } else if ch == "}" {
        pos += 1
        mode = .end
      } else {
        throw SyntaxError("expected ',' or '}', actual '\(ch)'")
      }
    case .end:
      break
    }
  }

  if mode != .end {
    throw SyntaxError("incomplete expression, mode \(mode)")
  }

  let token = ObjectToken(type: .object, members: members)

  return JsonCore.JsonParseResult(skip: pos, token: token)
}
