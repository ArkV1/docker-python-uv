ARG PYTHON_VERSION=3.11
FROM python:${PYTHON_VERSION}-slim

# Install curl and CA certificates
RUN apt-get update && \
    apt-get install -y curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install uv and set up environment
SHELL ["/bin/bash", "-c"]
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    source /root/.local/bin/env && \
    uv --version

# Add uv to PATH for all subsequent commands
ENV PATH="/root/.local/bin:${PATH}"

# Set default command to python
CMD ["python3"] 