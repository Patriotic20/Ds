FROM python:3.14-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1

# uv: fast, reproducible installs from uv.lock
COPY --from=ghcr.io/astral-sh/uv:0.5.11 /uv /uvx /usr/local/bin/

WORKDIR /app

# Install deps first (layer-cache friendly): copy only lock + project metadata.
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-install-project --no-dev

# Now copy source and install the project itself.
COPY . .
RUN uv sync --frozen --no-dev

# Run as non-root.
RUN useradd --create-home --shell /bin/bash app && chown -R app:app /app
USER app

ENV PATH="/app/.venv/bin:$PATH"

# Default command — overridable in compose.
CMD ["python", "main.py"]
