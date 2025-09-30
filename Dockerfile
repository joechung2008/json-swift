# Build stage
FROM swift:6.2-jammy AS build
WORKDIR /build
COPY . .
RUN swift build -c release

# Runtime stage
FROM swift:6.2-jammy-slim
WORKDIR /app
COPY --from=build /build/.build/release/json-swift /usr/local/bin/json-swift
COPY --from=build /build/LICENSE /app/
COPY --from=build /build/README.md /app/
ENTRYPOINT ["json-swift"]
