#!/bin/bash
while pgrep -f setup-diarization.sh > /dev/null; do
    sleep 5
done
python3 evals/test_pause_resume.py
