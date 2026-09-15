# Local Model Summarizer & Speaker Resolution Architecture

RecordBot supports **100% offline, local LLM execution** on Apple Silicon (M-series chips via Metal GPU acceleration) for automated meeting summarization, speaker identification, and action-item extraction.

---

## 1. Overview & Motivation

Previously, generating meeting summaries and resolving `Speaker N` labels to real coworker names required either manual copy-pasting to Claude or relying on external cloud APIs (Gemini/Anthropic).

The local model architecture introduces:
1. **Privacy & Security**: Meeting transcripts and user notes never leave your local machine.
2. **Zero API Dependency & Zero Cost**: Operates entirely on the local Apple Silicon GPU via Ollama.
3. **Automated Pipeline**: Instantly executes upon meeting completion within `transcribe.sh`.
4. **Multi-tier Fallback**: Configurable to prefer local models with transparent fallback to cloud APIs if the local server is stopped.

---

## 2. Configuration (`scripts/config.sh`)

Configure your preferred backend and model in `scripts/config.sh`:

```bash
# Summarizer backend:
#   local     use local Ollama model (100% offline & private on Apple Silicon)
#   gemini    use Gemini Flash API (via .gemini_token or GEMINI_API_KEY)
#   anthropic use Anthropic Claude API (via ANTHROPIC_API_KEY)
#   auto      try local Ollama first, fallback to Gemini API if unavailable
SUMMARIZER_BACKEND="local"

# Local LLM model in Ollama:
#   qwen2.5:14b  high quality 14B model (flawless speaker resolution & actions)
#   llama3.1:8b  fast 8B model
LOCAL_LLM_MODEL="qwen2.5:14b"

# Ollama server endpoint
OLLAMA_HOST="http://localhost:11434"
```

---

## 3. Evaluation & Benchmarking Suite

RecordBot includes a dedicated evaluation framework to benchmark local LLM models against gold ground-truth datasets:

### Test Suites:
1. **Unit Tests** (`evals/test_summarizer.py`):
   - Validates prompt construction, YAML frontmatter extraction, and markdown table parsing.
2. **Schema & Contract Tests** (`evals/test_contract.py`):
   - Enforces frontmatter tags, markdown action table columns (`Owner`, `Action`, `Due`, `Source`, `Confidence`), and index synchronization.
3. **Gold Regression Benchmark** (`evals/test_summarizer.py --benchmark`):
   - Tests the local model on historical meetings against `evals/gold/speakers.json` and `evals/gold/actions.json`.
   - Computes:
     - **Speaker Resolution Accuracy**: Precision of mapping `Speaker N` to correct names.
     - **Action Item Recall**: Coverage of mandatory action items.
     - **Inference Latency**: Average time per meeting.

### Running Evals & Benchmarks:
```bash
# Run all standard unit, summarizer, contract, and gold tests:
bash scripts/eval.sh

# Run end-to-end local LLM benchmark:
python evals/test_summarizer.py --benchmark --backend local --model qwen2.5:14b

# Run benchmark against Gemini API:
python evals/test_summarizer.py --benchmark --backend gemini
```

---

## 4. Automated Evaluation Logging

Every execution of `run.py` and `test_summarizer.py` automatically produces structured logs in `evals/logs/`:
- `evals/logs/latest_eval.log`: Text transcript of the latest test run.
- `evals/logs/eval_run_<timestamp>.log`: Historical run log for regression analysis.
- `evals/logs/latest_summarizer.json`: JSON payload containing accuracy metrics, latency, and per-meeting results.
