import subprocess
import time
import os

WAV_FILE = "Recordings/2026-09-09_21-02-31.wav"

def get_process_states():
    res = subprocess.run("ps -eo pid,stat,comm | grep -E 'transcribe.sh|whisper-cli|summarize.py' | grep -v grep", shell=True, capture_output=True, text=True)
    return res.stdout

print("Starting long transcription...")
proc = subprocess.Popen(["bash", "scripts/transcribe.sh", WAV_FILE], preexec_fn=os.setsid)
time.sleep(10) # wait for whisper-cli to start

states_before = get_process_states()

print("Sending PAUSE (SIGSTOP)...")
subprocess.run("pkill -STOP -f transcribe.sh; pkill -STOP -f whisper-cli; pkill -STOP -f summarize.py", shell=True)
time.sleep(3)

states_after = get_process_states()

print("Sending RESUME (SIGCONT)...")
subprocess.run("pkill -CONT -f transcribe.sh; pkill -CONT -f whisper-cli; pkill -CONT -f summarize.py", shell=True)
time.sleep(3)

states_resumed = get_process_states()

print("Killing process to end test...")
subprocess.run("pkill -TERM -f transcribe.sh; pkill -TERM -f whisper-cli; pkill -TERM -f summarize.py", shell=True)

print("\n--- OS PROCESS STATE RESULTS ---")
print("States Before Pause:\n" + states_before)
print("States After Pause:\n" + states_after)
print("States After Resume:\n" + states_resumed)
