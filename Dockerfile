# Use Python 3.11 slim as the base image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive \
    HERMES_HOME=/home/hermes/.hermes \
    PATH="/usr/local/bin:/home/hermes/.local/bin:$PATH"

# Install system dependencies
# Includes: git, curl, build-essential for compilation, 
# ripgrep for file search, ffmpeg for voice/audio,
# and libraries required by Playwright (Chromium)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    gnupg \
    build-essential \
    python3-dev \
    libffi-dev \
    ripgrep \
    ffmpeg \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libmesa-glx \
    libgbm1 \
    libasound2 \
    libpango-1.0-0 \
    libcairo2 \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install uv (fast Python package manager)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Create a non-root user to run the agent
RUN useradd -m -s /bin/bash hermes
WORKDIR /opt/hermes-agent

# Clone the Hermes Agent repository
RUN git clone https://github.com/NousResearch/hermes-agent.git .

# Install Python dependencies using uv
# We install with [all] to include browser, voice, and gateway tools
RUN uv pip install --system -e ".[all]"

# Install Node.js dependencies (required for browser tools and WhatsApp)
RUN npm install && \
    cd scripts/whatsapp-bridge && npm install

# Install Playwright browser engine
RUN npx playwright install chromium

# Set up the .hermes data directory with correct permissions
RUN mkdir -p $HERMES_HOME/cron \
    $HERMES_HOME/sessions \
    $HERMES_HOME/logs \
    $HERMES_HOME/pairing \
    $HERMES_HOME/hooks \
    $HERMES_HOME/image_cache \
    $HERMES_HOME/audio_cache \
    $HERMES_HOME/memories \
    $HERMES_HOME/skills \
    $HERMES_HOME/whatsapp/session && \
    cp cli-config.yaml.example $HERMES_HOME/config.yaml && \
    chown -R hermes:hermes /home/hermes /opt/hermes-agent

# Switch to the non-root user
USER hermes
WORKDIR /home/hermes

# The entrypoint is the hermes command
ENTRYPOINT ["hermes"]

# Default command starts the messaging gateway, which is ideal for Docker/Dokploy
# Users can override this to run 'chat' or other commands
CMD ["gateway"]