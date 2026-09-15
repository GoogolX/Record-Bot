# RecordBot settings. Edit freely.

# ---- Transcription ----------------------------------------------------------

# Whisper model. large-v3-turbo is multilingual and handles accented English far
# better than the .en models, while running faster than medium on Metal.
#   ggml-large-v3-turbo-q5_0.bin  ~800 MB, the default, very little accuracy lost
#   ggml-large-v3-turbo.bin       ~1.6 GB, full precision
#   ggml-small.en.bin             ~500 MB, English only, much weaker on accents
WHISPER_MODEL="ggml-large-v3-turbo-q5_0.bin"

# Force a language. Multilingual models sometimes decide a heavily accented
# passage is another language and start translating it, which this prevents.
# Set to "auto" if your meetings genuinely switch languages mid-sentence.
WHISPER_LANGUAGE="en"

# Threads for whisper. Empty means every core.
WHISPER_THREADS="2"

# Vocabulary / initial prompt for whisper. Biases recognition toward technical
# terms, acronyms, and proper names rather than phonetic misinterpretations.
WHISPER_PROMPT="AWS, EDW, CDC, QTest, PO, IRGR, Power BI, ETL, DMOD, DBT, SF"

# ---- Speakers --------------------------------------------------------------

# Diarization: who spoke when.
#   auto  run it when scripts/setup-diarization.sh has been run, skip otherwise
#   yes   run it, and fail loudly if it is not installed
#   no    never run it
DIARIZE="auto"

# Speaker count hints. pyannote is noticeably better when it knows roughly how
# many people to expect. Leave empty to let it decide.
MIN_SPEAKERS="1"
MAX_SPEAKERS="8"

# Your name, used for the track that comes from your own microphone.
MY_NAME="Kaushik"

# ---- Summarization --------------------------------------------------------

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

# ---- Storage ---------------------------------------------------------------

# Keep the raw audio after transcription? Meeting audio runs about 5 MB/minute
# per track. Failed jobs always keep their audio so a retry is possible.
# Set to "yes" to preserve test sets for evals and benchmarking.
KEEP_AUDIO="yes"
