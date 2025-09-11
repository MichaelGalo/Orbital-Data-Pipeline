FROM python:3.13-slim

# Install system dependencies and pipx
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pipx \
    && rm -rf /var/lib/apt/lists/*

# Ensure pipx installs binaries to PATH
ENV PATH=/root/.local/bin:$PATH

WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install uv globally and sync dependencies in a venv managed by uv
RUN pipx install uv \
    && pipx run uv sync --locked

# Copy the rest of the app
COPY . .

# Run the pipeline entirely via uv
CMD ["pipx", "run", "uv", "run", "-m", "src.runner"]
