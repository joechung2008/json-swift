# json-swift

## License

MIT

## Reference

[json.org](https://www.json.org)

## Build

To build the project, run:

```sh
swift build
```

## Format

To format Swift files, run:

```sh
swift format --in-place --recursive .
```

## Lint

To lint Swift files, run:

```sh
swift format lint --recursive .
```

Configure rules in `.swiftlint.yml` if needed.

## Run

To run the CLI:

```sh
swift run
```

## Running Unit Tests

To run all unit tests, execute the following command from the project root:

````sh
swift test

## Running Tests with Coverage

To run all tests and generate a coverage report:

```sh
swift test --enable-code-coverage
````

To locate the generated coverage report:

```sh
swift test --show-codecov-path
```

You can open the coverage report in Xcode or use third-party tools to visualize coverage data.

This will automatically discover and run all tests in the Tests/JsonCoreTests directory.
