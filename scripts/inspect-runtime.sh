#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:-ghcr.io/brucelovedecimal/vllm-omni-latest-version-docker:v0.28.0}"

echo "Inspecting ${IMAGE}"
docker run --rm --entrypoint python "${IMAGE}" - <<'PY'
import importlib.metadata as metadata
import platform
import sys

print(f"python={platform.python_version()}")
for package in ("torch", "vllm", "vllm-omni", "transformers", "diffusers", "accelerate", "safetensors"):
    try:
        print(f"{package}={metadata.version(package)}")
    except metadata.PackageNotFoundError:
        print(f"{package}=NOT_INSTALLED")

try:
    import torch
    print(f"torch.version.cuda={torch.version.cuda}")
    print(f"torch.cuda.is_available={torch.cuda.is_available()}")
    print(f"torch.cuda.device_count={torch.cuda.device_count()}")
    if torch.cuda.is_available():
        print(f"gpu0={torch.cuda.get_device_name(0)}")
except Exception as exc:
    print(f"torch.runtime_check={type(exc).__name__}: {exc}")
PY

docker run --rm --entrypoint bash "${IMAGE}" -lc '
  echo "uv=$(uv --version 2>/dev/null || echo NOT_INSTALLED)"
  echo "conda=$(conda --version 2>/dev/null || echo NOT_INSTALLED)"
  echo "cuda_compiler=$(nvcc --version 2>/dev/null | tail -1 || echo NOT_INSTALLED)"
  echo "nvidia_smi=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null | head -1 || echo NO_GPU_OR_NVIDIA_RUNTIME)"
  echo "--- pip freeze ---"
  python -m pip freeze
'
