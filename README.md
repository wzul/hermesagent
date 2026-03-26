# Hermes Agent - Docker & Dokploy Deployment

This repository provides a streamlined `Dockerfile` and `docker-compose.yml` optimized for running [Hermes Agent](https://github.com/NousResearch/hermes-agent) on **Dokploy**. 

## 🏗 Architecture: Sidecar Setup
This configuration uses a **Sidecar Pattern** to keep the agent lightweight:
- **Hermes Agent**: Handles LLM logic, messaging, and tool orchestration.
- **Browserless Sidecar**: A dedicated container for Playwright/Chrome, handling all web scraping and browser automation.

## 🚀 Dokploy Deployment Guide

1.  **Create a New Service**: In Dokploy, create a new service and select **Docker Compose**.
2.  **Configuration**: Paste the contents of the `docker-compose.yml` from this repository.
3.  **Environment Variables**: Add the required keys in the Dokploy UI (see below).
4.  **Deployment**: Click deploy. Dokploy will automatically build the image and orchestrate the two containers.

## 🔑 Required Environment Variables

The agent is pre-configured to use **Ollama Cloud** by default.

| Variable | Description | Default / Example |
| :--- | :--- | :--- |
| `OPENAI_BASE_URL` | LLM API endpoint | `https://ollama.com/v1` |
| `OPENAI_API_KEY` | Your API Key | `your-api-key` |
| `LLM_MODEL` | Default model name | `gemini-3-flash-preview` |
| `HERMES_INFERENCE_PROVIDER` | Provider mode | `main` |

### Messaging Platforms (Pick at least one)

| Variable | Description |
| :--- | :--- |
| `TELEGRAM_BOT_TOKEN` | Token from @BotFather |
| `TELEGRAM_ALLOWED_USERS` | Your Telegram User ID (Required for security) |
| `DISCORD_BOT_TOKEN` | Token from Discord Developer Portal |
| `SLACK_BOT_TOKEN` | Slack `xoxb` token |

## 📱 WhatsApp Pairing

If `WHATSAPP_ENABLED=true` is set:

1.  Open the Dokploy terminal for the `hermes-agent` container.
2.  Run: `hermes whatsapp`
3.  Scan the QR code displayed in the logs/terminal with your phone.

## 📁 Persistent Data
All agent state (sessions, memories, and skills) is stored in the `hermes_data` volume. This ensures your agent "remembers" you and retains its learned skills even if the container is redeployed or updated.

## 🛡 Security
**Important:** Always set `TELEGRAM_ALLOWED_USERS` (or the equivalent for your platform). By default, the gateway denies all users unless they are explicitly in the allowlist to protect your API credits and data.