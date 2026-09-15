import subprocess
import os
import shutil

MODELS = ["qwen2.5:14b", "qwen2.5:14b-instruct-q2_K", "qwen2.5:7b"]
FILE = "Transcripts/2026-09-09_19-18-56__call-with-ravi-to-clarify-open-questions.md"

with open(FILE, "r") as f:
    content = f.read()

# Replace status: summarized with status: awaiting-summary
if "status: summarized" in content:
    content = content.replace("status: summarized", "status: awaiting-summary")
    with open(FILE, "w") as f:
        f.write(content)

for model in MODELS:
    print(f"Generating summary with {model}...")
    
    # Remove existing summary file to ensure we get a new one
    out_file = "Summaries/2026-09-09_19-18-56__call-with-ravi-to-clarify-open-questions.md"
    if os.path.exists(out_file):
        os.remove(out_file)
        
    subprocess.run(["python3", "scripts/summarize.py", "--file", FILE, "--backend", "local", "--local-model", model])
    
    if os.path.exists(out_file):
        dest_file = f"Summaries/compare_{model.replace(':', '_')}.md"
        shutil.copy(out_file, dest_file)
        print(f"Saved to {dest_file}")
    else:
        print(f"Failed to generate summary for {model}")
        
    with open(FILE, "r") as f:
        content = f.read()
    if "status: summarized" in content:
        content = content.replace("status: summarized", "status: awaiting-summary")
        with open(FILE, "w") as f:
            f.write(content)

content = content.replace("status: awaiting-summary", "status: summarized")
with open(FILE, "w") as f:
    f.write(content)

print("Done!")
