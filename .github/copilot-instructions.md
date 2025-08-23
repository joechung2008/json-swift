# Copilot Instructions for `json-swift`

## Project Overview

- **Purpose:** Implements a JSON parser and pretty-printer in Swift. Provides a library (`JsonCore`) and a CLI executable (`json-swift`).
- **Architecture:**
  - `Sources/JsonCore/`: Core parsing logic, token types, and error handling.
  - `Sources/cli/`: CLI entry point and pretty-printing logic.
  - `Package.swift`: SwiftPM configuration; defines library and executable targets.

## Key Components

- **Token System:**
  - All JSON elements are represented as `Token` types (see `Token.swift`, `JsonType.swift`).
  - Specialized tokens: `ArrayToken`, `ObjectToken`, `PairToken`, `StringToken`, `NumberToken` (see respective files).
- **Parsing:**
  - Main entry: `JsonCore.parse(expression: String)` returns a `JsonParseResult` (see `JsonCore.swift`).
  - Array/object parsing: `parseArray`, `parseObject` (see `Array.swift`, `Object.swift`).
  - Error handling via `SyntaxError` (see `SyntaxError.swift`).
- **CLI:**
  - Reads from stdin, parses input, pretty-prints result (see `main.swift`, `prettyPrint.swift`).

## Developer Workflows

- **Build:**
  - Use Swift Package Manager: `swift build` (from project root).
- **Run CLI:**
  - `swift run json-swift < input.json`
- **Test:**
  - Unit tests are located in `Tests/JsonCoreTests/`.
  - To run all unit tests, execute:

```sh
swift test
```

  - This will automatically discover and run all tests.
  - To add new tests, create a file in `Tests/JsonCoreTests/` and define a public class inheriting from `XCTestCase` with methods starting with `test`.

## Project-Specific Patterns

- **Parsing State Machines:**
  - Parsers use explicit state enums (`Mode`) for control flow.
  - Error messages are descriptive and thrown as `SyntaxError`.
- **Pretty Printing:**
  - Indentation is managed recursively in `prettyPrint.swift`.
- **Type Safety:**
  - Downcasting is used to access specialized token properties (e.g., `as? ArrayToken`).

## Integration Points

- **No external dependencies** beyond Swift standard library.
- **CLI depends on `JsonCore`** for parsing logic.

## Example: Parsing and Pretty Printing

```swift
let result = try JsonCore.parse(jsonString)
prettyPrint(result.token)
```

## Key Files

- `Sources/JsonCore/JsonCore.swift`: Main parser entry point
- `Sources/cli/main.swift`: CLI logic
- `Sources/cli/prettyPrint.swift`: Pretty printer
- `Package.swift`: Project configuration
- `Tests/JsonCoreTests/`: Unit tests

---

_If any conventions or workflows are unclear, please specify for further documentation._
