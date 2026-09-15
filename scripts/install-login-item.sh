#!/bin/bash
# Starts RecordBot.app at login via a LaunchAgent.
set -euo pipefail

HOME_DIR="${RECORDBOT_HOME:-$(cd "$(dirname "$0")/.." && pwd)}"
APP="$HOME_DIR/RecordBot.app"
PLIST="$HOME/Library/LaunchAgents/com.recordbot.menubar.plist"

[ -d "$APP" ] || { echo "RecordBot.app not built yet. Run scripts/setup.sh first." >&2; exit 1; }

mkdir -p "$HOME/Library/LaunchAgents"
cat > "$PLIST" <<PLISTEOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.recordbot.menubar</string>
    <key>ProgramArguments</key>
    <array>
        <string>$APP/Contents/MacOS/RecordBot</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>RECORDBOT_HOME</key>
        <string>$HOME_DIR</string>
    </dict>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
</dict>
</plist>
PLISTEOF

launchctl unload "$PLIST" 2>/dev/null || true
launchctl load "$PLIST"
echo "Installed. RecordBot will start at login."
echo "To undo: launchctl unload '$PLIST' && rm '$PLIST'"
