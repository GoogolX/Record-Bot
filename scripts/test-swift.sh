#!/bin/bash
# Run capture regressions with the installed Swift Testing framework.
set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"
developer_dir="$(xcode-select -p)"
framework_dir="$developer_dir/Library/Developer/Frameworks"
if [ -d "$framework_dir/Testing.framework" ]; then
    exec swift test \
        -Xswiftc -F -Xswiftc "$framework_dir" \
        -Xlinker -F -Xlinker "$framework_dir" \
        -Xlinker -rpath -Xlinker "$framework_dir" \
        -Xlinker -rpath -Xlinker "$developer_dir/Library/Developer/usr/lib" \
        -Xlinker -framework -Xlinker Testing "$@"
fi
exec swift test "$@"
