FROM python:3.13-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pipx \
    && rm -rf /var/lib/apt/lists/*

ENV PATH=/root/.local/bin:$PATH

WORKDIR /app

COPY pyproject.toml uv.lock ./

RUN pipx install uv \
    && pipx run uv sync --locked

COPY . .

CMD ["pipx", "run", "uv", "run", "-m", "src.runner"]
