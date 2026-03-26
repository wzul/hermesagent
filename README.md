# Hermes Agent - Docker & Dokploy Deployment

This repository provides a `Dockerfile` and `docker-compose.yml` to run [Hermes Agent](https://github.com/NousResearch/hermes-agent) in a containerized environment. This setup is optimized for **Dokploy** or any standard Docker-based hosting provider.

## 🚀 Quick Start

1.  **Clone this configuration** to your server or local machine.
2.  **Create an `.env` file** based on the environment variables section below.
3.  **Deploy with Docker Compose**:
    ```bash
    docker-compose up -d
    ```

## 🛠 Dokploy Deployment

1.  **Create a New Service** in Dokploy.
2.  **Select Docker Compose** as the deployment type.
3.  **Paste the contents** of the provided `docker-compose.yml`.
4.  **Add Environment Variables** in the Dokploy dashboard (see below).
5.  **Persistent Storage**: Dokploy will automatically handle the `hermes_data` volume to ensure your sessions, memories, and skills persist across restarts.

## 🔑 Required Environment Variables

To function, Hermes needs at least one LLM provider (OpenRouter is recommended).

| Variable | Description | Source |
| :--- | :--- | :--- |
| `OPENROUTER_API_KEY` | Your OpenRouter API Key | [openrouter.ai](https://openrouter.ai/keys) |
| `LLM_MODEL` | Default model (e.g., `anthropic/claude-3.5-sonnet`) | [openrouter.ai/models](https://openrouter.ai/models) |

### Messaging Platforms (Pick at least one)

| Variable | Description |
| :--- | :--- |
| `TELEGRAM_BOT_TOKEN` | Token from @BotFather |
| `DISCORD_BOT_TOKEN` | Token from Discord Developer Portal |
| `SLACK_BOT_TOKEN` | `xoxb-...` token |
| `SLACK_APP_TOKEN` | `xapp-...` token (Socket Mode) |
| `TELEGRAM_ALLOWED_USERS`| Comma-separated User IDs (Highly Recommended) |

## 📱 WhatsApp Pairing

If you enable WhatsApp (`WHATSAPP_ENABLED=true`), you must pair the device manually after the container starts:

1.  Run the pairing command:
    ```bash
    docker exec -it hermes-agent hermes whatsapp
    ```
2.  **Scan the QR Code** that appears in your terminal with your phone.
3.  The session will be saved in the persistent volume.

## 📁 Persistent Data

The container stores all its state in `/home/hermes/.hermes`. In the `docker-compose.yml`, this is mapped to a named volume `hermes_data`. This includes:

*   **Sessions**: Past conversation history.
*   **Memories**: Learnt facts about you and the environment.
*   **Skills**: Custom tools the agent has created.
*   **Logs**: Detailed execution trajectories.
*   **Config**: Your `config.yaml` is initialized here on first run.

## 🖥 Local CLI Usage

If you want to use the interactive CLI instead of the messaging gateway:

```bash
docker run -it --env-file .env -v hermes_data:/home/hermes/.hermes hermes-agent:latest chat
```

## 🛡 Security Note

By default, `GATEWAY_ALLOW_ALL_USERS` is set to `false`. Ensure you provide your User ID in `TELEGRAM_ALLOWED_USERS` (or equivalent) so that only you can interact with your agent.