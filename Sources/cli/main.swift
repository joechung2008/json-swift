import Foundation
import JsonCore

func main() {
  do {
    // Read input from standard input, trimming trailing newlines
    let input =
      (String(data: FileHandle.standardInput.readDataToEndOfFile(), encoding: .utf8) ?? "")
      .trimmingCharacters(in: .newlines)

    // Try parsing the input as JSON
    let result = try JsonCore.parse(input)

    // Pretty print the parsed JSON result
    prettyPrint(result.token)
  } catch {
    print("Error: \(error)")
  }
}

main()
