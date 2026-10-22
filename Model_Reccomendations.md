# Local Coding Models: GPU VRAM and Recommended Settings

These recommendations assume a **single NVIDIA GPU** running a local coding model through Ollama or llama.cpp. VRAM tiers are practical starting points—not guaranteed minimums. Model weights, context length, runtime overhead, and other GPU applications all use memory.

## Model and configuration recommendations

| GPU VRAM | Model to try | Ollama starting configuration | llama.cpp starting configuration |
|---:|---|---|---|
| **8 GB** | `gemma4:e4b` Q4 — fallback for this tier | `num_ctx: 8192`; `num_batch: 128` | `--ctx-size 8192 -b 256 -ub 128` |
| **12–16 GB** | `gemma4:12b` Q4 | `num_ctx: 16384`; `num_batch: 256` | `--ctx-size 16384 -b 256 -ub 128` |
| **24 GB** | `qwen3.6:27b-q4_K_M` | Start at `num_ctx: 16384`; try 32K if it fits comfortably; `num_batch: 256` | `--ctx-size 16384 -b 512 -ub 256` |
| **32 GB** | `qwen3.6:35b-a3b-coding` | Start at `num_ctx: 16384`; try 32K if there’s room; `num_batch: 256` | `--ctx-size 16384 -b 512 -ub 256` |
| **48 GB** | `qwen3.6:27b-q8_0` | `num_ctx: 32768`; `num_batch: 512` | `--ctx-size 32768 -b 512 -ub 256` |
| **80 GB+** | `qwen3.6:27b-bf16` | Start at `num_ctx: 65536`; `num_batch: 512` | `--ctx-size 65536 -b 512 -ub 256` |

The Qwen3.6 Q4, Q8, and BF16 model files are listed at about **17 GB, 30 GB, and 56 GB**, respectively. The 35B-A3B coding option is listed at around **23–24 GB**. These are model-file sizes, not total runtime VRAM requirements; leave additional memory for context and runtime overhead.

## Ollama setup

Ollama supports `num_ctx` and `num_batch` as model options. A Modelfile can create a model variant with a chosen context size.

Example for the 24 GB tier:

```text
FROM qwen3.6:27b-q4_K_M
PARAMETER num_ctx 16384
PARAMETER num_batch 256
```

Save this as `Modelfile`, then run:

```bash
ollama create qwen27b-16k -f Modelfile
ollama launch claude --model qwen27b-16k
```

For a single-user coding session:

- Keep parallel requests at one.
- Enable Flash Attention if supported.
- Leave the KV cache at its default precision if it fits.
- If memory is tight, try Q8 KV-cache quantization and test it on your usual tasks.

Check the model’s actual memory use with:

```bash
ollama ps
```

## llama.cpp setup

Use a **GGUF file** that matches the model and quantization in the table. An Ollama model tag is not itself a file path for `llama-server`.

Example for the 24 GB tier:

```bash
llama-server \
  -m /models/qwen3.6-27b-q4_K_M.gguf \
  --alias local-qwen \
  --host 127.0.0.1 \
  --port 8080 \
  --n-gpu-layers all \
  --ctx-size 16384 \
  --parallel 1 \
  --flash-attn on \
  --jinja \
  -b 512 \
  -ub 256
```

- `--n-gpu-layers all` aims to keep the model on the GPU.
- `--parallel 1` limits the server to one concurrent request.
- `--jinja` enables the model’s chat template, which matters for tool use.
- `--ctx-size` sets the context size.
- `-b` and `-ub` control prompt-processing batch sizes; reduce them if you run out of memory.

llama.cpp supports an Anthropic-compatible Messages API for connecting Claude Code to a local model.

## General tuning notes

- Start with the context size in the table, then increase it only if VRAM allows.
- If a run runs out of VRAM, reduce the context size or batch size. Q8 KV-cache quantization is another option.
- Keep the model’s recommended sampling defaults initially; don’t assume lowering temperature improves coding-agent reliability.
- Prefer a higher-quality model quantization when it fits comfortably, rather than using an unnecessarily large context that leaves little memory for the model.
- Advertised maximum context lengths are not the same as practical context lengths on your GPU.

## References

- [Ollama Modelfile documentation](https://docs.ollama.com/modelfile)
- [Ollama Claude Code integration](https://docs.ollama.com/integrations/claude-code)
- [Ollama FAQ](https://docs.ollama.com/faq)
- [llama.cpp server documentation](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md)
- [Ollama model library](https://ollama.com/library)
