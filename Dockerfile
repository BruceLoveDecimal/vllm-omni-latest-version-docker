# Stable, upstream-aligned vLLM-Omni runtime.
# The official vLLM image supplies Python, PyTorch, vLLM, CUDA-compatible
# runtime libraries, and the compiled serving stack. vLLM-Omni is installed
# separately at the matching stable version from PyPI.
ARG IMAGE_VERSION=0.28.0
FROM --platform=$TARGETPLATFORM vllm/vllm-openai:${IMAGE_VERSION}

ARG IMAGE_VERSION

LABEL org.opencontainers.image.title="vLLM-Omni stable runtime" \
      org.opencontainers.image.description="Reproducible vLLM-Omni CUDA runtime" \
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.source="https://github.com/BruceLoveDecimal/vllm-omni-latest-version-docker" \
      org.opencontainers.image.documentation="https://github.com/BruceLoveDecimal/vllm-omni-latest-version-docker#readme" \
      org.opencontainers.image.vendor="BruceLoveDecimal"

ENV VLLM_OMNI_IMAGE_VERSION=${IMAGE_VERSION}

RUN uv pip install --system --no-cache-dir "vllm-omni==${IMAGE_VERSION}"

# Keep the upstream image's runtime and entrypoint semantics. Supply the
# serving command explicitly at `docker run` time so no model is implicit.
ENTRYPOINT []
