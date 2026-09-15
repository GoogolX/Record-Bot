import subprocess
import time
import json
import threading

MODELS = ["qwen2.5:14b", "qwen2.5:14b-instruct-q2_K", "qwen2.5:7b", "llama3.1:8b"]
TEST_FILE = "Transcripts/2026-09-09_21-02-31__two-calls-lakshmi-vf-daily-standup-call.md"

max_ram = 0

def monitor_ram():
    global max_ram
    max_ram = 0
    while getattr(threading.current_thread(), "do_run", True):
        res = subprocess.run("ps -eo rss,comm | grep ollama | awk '{sum+=$1} END {print sum}'", shell=True, capture_output=True, text=True)
        try:
            ram_kb = int(res.stdout.strip())
            if ram_kb > max_ram:
                max_ram = ram_kb
        except:
            pass
        time.sleep(1)

def evaluate_model(model):
    global max_ram
    results = {}
    print(f"\n--- Evaluating {model} ---")
    
    subprocess.run(["ollama", "stop", model], capture_output=True)
    time.sleep(2)
    
    t = threading.Thread(target=monitor_ram)
    t.do_run = True
    t.start()
    
    t0 = time.time()
    print("Running gold benchmark...")
    cmd_bench = ["python3", "evals/test_summarizer.py", "--benchmark", "--backend", "local", "--model", model]
    bench_res = subprocess.run(cmd_bench, capture_output=True, text=True)
    
    print("Running 83-minute transcript summary...")
    t1 = time.time()
    cmd_long = ["python3", "scripts/summarize.py", "--file", TEST_FILE, "--backend", "local", "--model", model]
    long_res = subprocess.run(cmd_long, capture_output=True, text=True)
    long_latency = time.time() - t1
    
    t.do_run = False
    t.join()
    
    subprocess.run(["curl", "-X", "POST", "http://localhost:11434/api/generate", "-d", f'{{"model": "{model}", "keep_alive": 0}}'])
    
    results = {
        "model": model,
        "benchmark_output": bench_res.stdout,
        "long_latency": long_latency,
        "long_success": long_res.returncode == 0,
        "peak_ram_mb": max_ram / 1024.0
    }
    
    with open(f"evals/logs/memory_eval_{model.replace(':', '_')}.json", "w") as f:
        json.dump(results, f, indent=2)

if __name__ == "__main__":
    for m in MODELS:
        evaluate_model(m)
