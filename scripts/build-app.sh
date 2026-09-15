#!/bin/bash
# Compiles the Swift sources and assembles RecordBot.app.
# The app bundle matters: macOS ties the Screen Recording permission to a signed
# bundle identity, so a bare binary run from Terminal would re-prompt forever.
set -euo pipefail

HOME_DIR="${RECORDBOT_HOME:-$(cd "$(dirname "$0")/.." && pwd)}"
cd "$HOME_DIR"

APP="$HOME_DIR/RecordBot.app"

echo "Compiling (release)..."
swift build -c release

BIN_PATH="$(swift build -c release --show-bin-path)"

echo "Assembling app bundle..."
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$BIN_PATH/RecordBot" "$APP/Contents/MacOS/RecordBot"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>RecordBot</string>
    <key>CFBundleDisplayName</key>
    <string>RecordBot</string>
    <key>CFBundleIdentifier</key>
    <string>com.recordbot.menubar</string>
    <key>CFBundleExecutable</key>
    <string>RecordBot</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSMicrophoneUsageDescription</key>
    <string>RecordBot records your microphone as a separate track so your own speech can be identified and transcribed accurately.</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
PLIST

echo "Signing (ad-hoc)..."
codesign --force --deep --sign - "$APP"

echo "Built: $APP"
