import JsonCore

public func prettyPrint(_ token: Token?, indent: String = "") {
  guard let token = token else {
    print("\(indent)null")
    return
  }
  switch token.type {
  case .array:
    if let array = token as? ArrayToken {
      print("\(indent)[")
      for value in array.values {
        prettyPrint(value, indent: indent + "  ")
      }
      print("\(indent)]")
    }
  case .object:
    if let object = token as? ObjectToken {
      print("\(indent){")
      for pair in object.members {
        if let key = pair.key?.value {
          print("\(indent)  \"\(key)\": ", terminator: "")
          prettyPrint(pair.value, indent: indent + "  ")
        }
      }
      print("\(indent)}")
    }
  case .string:
    if let string = token as? StringToken {
      print("\(indent)\"\(string.value ?? "")\"")
    }
  case .number:
    if let number = token as? NumberToken {
      print("\(indent)\(number.value ?? 0)")
    }
  case .trueType:
    print("\(indent)true")
  case .falseType:
    print("\(indent)false")
  case .null:
    print("\(indent)null")
  default:
    print("\(indent)unknown")
  }
}
