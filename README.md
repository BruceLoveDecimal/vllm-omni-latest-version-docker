# vLLM-Omni stable Docker runtime

This repository publishes a reproducible, user-owned image based on the
official stable `vllm/vllm-omni:0.28.0` image.

## Version alignment

| Component | Version / policy |
| --- | --- |
| vLLM-Omni | `0.28.0` |
| vLLM | `0.28.0` |
| CUDA | CUDA 13.0-compatible binaries (upstream default) |
| Python / PyTorch / transitive packages | inherited from the pinned upstream image and inspectable with `scripts/inspect-runtime.sh` |
| Conda | intentionally not added; use the upstream image's Python/uv runtime |

The upstream project recommends a fresh environment because vLLM's compiled
CUDA kernels are sensitive to CUDA and PyTorch combinations. It also notes
that Conda-installed PyTorch can statically link NCCL and conflict with vLLM.
See the [official CUDA installation guide](https://github.com/vllm-project/vllm-omni/blob/main/docs/getting_started/installation/gpu/cuda.inc.md).

## Pull the published image

```bash
docker pull ghcr.io/brucelovedecimal/vllm-omni-latest-version-docker:v0.28.0
```

The `latest` tag points to the same stable release:

```bash
docker pull ghcr.io/brucelovedecimal/vllm-omni-latest-version-docker:latest
```

## Run on NVIDIA GPUs

Install Docker plus the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html), then run:

```bash
docker run --rm --gpus all \
  --ipc=host \
  -p 8091:8091 \
  -v "$HOME/.cache/huggingface:/root/.cache/huggingface" \
  -e HF_TOKEN="$HF_TOKEN" \
  ghcr.io/brucelovedecimal/vllm-omni-latest-version-docker:v0.28.0 \
  vllm serve Qwen/Qwen3-Omni-30B-A3B-Instruct --omni --port 8091
```

The model above is large and the upstream example was verified on two H100s.
Use a smaller model for a smoke test. Do not bake model weights or tokens into
the image.

## Inspect every runtime dependency

```bash
chmod +x scripts/inspect-runtime.sh
./scripts/inspect-runtime.sh
```

This prints Python, PyTorch, vLLM, vLLM-Omni, CUDA, driver visibility, Conda/
uv presence, and the complete `pip freeze` output from the image.

## Publishing

GitHub Actions publishes multi-architecture `linux/amd64` and `linux/arm64`
images to GHCR when a `v*` tag is pushed. A manual workflow dispatch can
publish another upstream stable tag by setting `image_version`.
