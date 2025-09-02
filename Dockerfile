# ---------- Stage 1: Build dependencies ----------
FROM python:3.9-slim AS builder

# Set working dir
WORKDIR /app

# Install build tools (needed for some Python packages with C extensions)
RUN apt-get update && apt-get install -y \
    build-essential gcc libpq-dev --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Copy only requirements to leverage Docker cache
COPY requirements.txt .

# Install deps into a clean target folder
RUN pip install --prefix=/install -r requirements.txt


# ---------- Stage 2: Runtime image ----------
FROM python:3.9-slim

# Set working dir
WORKDIR /app/backend

# Copy installed packages from builder stage
COPY --from=builder /install /usr/local

# Copy application source
COPY . .

# Expose Django dev port
EXPOSE 8000

# Run Django (dev mode)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

