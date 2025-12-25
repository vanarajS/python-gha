# =========================
# Stage 1 — Builder
# =========================
FROM python:3.11-slim AS builder

# Prevents Python from writing pyc files and enables unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# System deps needed only to build wheels (example: gcc for native deps)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first (layer caching)
COPY app/requirements.txt .

# Build wheels instead of installing directly
RUN pip install --upgrade pip \
    && pip wheel --no-cache-dir --no-deps --wheel-dir /wheels -r requirements.txt


# =========================
# Stage 2 — Runtime
# =========================
FROM python:3.11-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copy only prebuilt wheels from builder
COPY --from=builder /wheels /wheels

# Install runtime dependencies only
RUN pip install --no-cache-dir /wheels/* \
    && rm -rf /wheels

# Copy application code
COPY app/ app/

# Non-root user (optional but recommended)
RUN useradd -m appuser
USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
