# Hermes Agent - Docker & Dokploy Deployment (Sidecar Edition)

This repository provides a optimized `Dockerfile` and `docker-compose.yml` to run [Hermes Agent](https://github.com/NousResearch/hermes-agent) in a containerized environment. This version uses a **Browserless Sidecar** for Playwright, which keeps the main agent image lightweight and separates the heavy browser rendering into a dedicated container.

## 🚀 Quick Start

1.  **Clone this configuration** to your server or local machine.
2.  **Create an `.env` file** (see Environment Variables below).
3.  **Deploy with Docker Compose**:
    ```bash
    docker-compose up -d
    ```

## 🛠 Dokploy Deployment

1.  **Create a New Service** in Dokploy.
2.  **Select Docker Compose** as the deployment type.
3.  **Paste the contents** of the provided `docker-compose.yml`.
4.  **Add Environment Variables** in the Dokploy dashboard.
5.  **Persistent Storage**: Dokploy will manage the `hermes_data` volume to ensure your sessions, memories, and skills persist across restarts.

## 🏗 Architecture: Playwright Sidecar

The agent is configured to use `browserless/chrome` as a sidecar. 

- **Hermes Agent Container**: Contains only the Python/Node logic. No heavy GUI libraries or Chromium binaries are installed here.
- **Browserless Container**: A dedicated, optimized headless Chrome instance. 
- **Communication**: The agent connects via WebSockets (`ws://browserless:3000`).

## 🔑 Required Environment Variables

| Variable | Description | Default / Example |
| :--- | :--- | :--- |
| `OPENAI_BASE_URL` | Ollama Cloud API endpoint | `https://ollama.com/v1` |
| `OPENAI_API_KEY` | Your Ollama Cloud API Key | `your-api-key` |
| `LLM_MODEL` | Default model name | `llama3.1` |
| `HERMES_INFERENCE_PROVIDER` | Set to `main` for Ollama Cloud | `main` |

### Messaging Platforms (Pick at least one)

| Variable | Description |
| :--- | :--- |
| `TELEGRAM_BOT_TOKEN` | Token from @BotFather |
| `DISCORD_BOT_TOKEN` | Token from Discord Developer Portal |
| `SLACK_BOT_TOKEN` | `xoxb-...` token |
| `SLACK_APP_TOKEN` | `xapp-...` token (Socket Mode) |
| `TELEGRAM_ALLOWED_USERS`| Comma-separated User IDs (Highly Recommended) |

## 📱 WhatsApp Pairing

If you enable WhatsApp (`WHATSAPP_ENABLED=true`):

1.  Run the pairing command in the agent container:
    ```bash
    docker exec -it hermes-agent hermes whatsapp
    ```
2.  **Scan the QR Code** in your terminal with your phone.

## 📁 Persistent Data

The volume `hermes_data` persists:
*   **Sessions**: Conversation history.
*   **Memories**: Learnt facts about you.
*   **Skills**: Custom tools created by the agent.
*   **Logs**: Detailed execution trajectories.

## 🛡 Security Note

Ensure you set `TELEGRAM_ALLOWED_USERS` (or platform equivalent) to prevent unauthorized access to your agent and your LLM credits.