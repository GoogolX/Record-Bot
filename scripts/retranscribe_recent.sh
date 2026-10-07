#!/bin/bash
FILES=(
    "Recordings/2026-09-23_09-31-58.wav"
    "Recordings/2026-09-23_10-01-48.wav"
    "Recordings/2026-09-23_20-30-59.wav"
    "Recordings/2026-09-23_21-01-41.wav"
    "Recordings/2026-09-24_09-35-49.wav"
)
for f in "${FILES[@]}"; do
    if [ -f "$f" ]; then
        echo "Retranscribing $f..."
        ./scripts/transcribe.sh "$f"
    fi
done
