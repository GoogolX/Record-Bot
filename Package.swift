// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "RecordBot",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "RecordBot",
            path: "Sources/RecordBot"
        )
    ]
)
