# Stable, upstream-aligned vLLM-Omni runtime.
# The upstream image already contains Python, PyTorch, vLLM, vLLM-Omni,
# CUDA-compatible runtime libraries, and the platform dependencies.
ARG IMAGE_VERSION=0.28.0
FROM --platform=$TARGETPLATFORM vllm/vllm-omni:${IMAGE_VERSION}

ARG IMAGE_VERSION

LABEL org.opencontainers.image.title="vLLM-Omni stable runtime" \
      org.opencontainers.image.description="Reproducible vLLM-Omni CUDA runtime" \
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.source="https://github.com/BruceLoveDecimal/vllm-omni-latest-version-docker" \
      org.opencontainers.image.documentation="https://github.com/BruceLoveDecimal/vllm-omni-latest-version-docker#readme" \
      org.opencontainers.image.vendor="BruceLoveDecimal"

ENV VLLM_OMNI_IMAGE_VERSION=${IMAGE_VERSION}

# Keep the upstream image's runtime and entrypoint semantics. Supply the
# serving command explicitly at `docker run` time so no model is implicit.
ENTRYPOINT []
