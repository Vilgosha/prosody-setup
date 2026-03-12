# prosody-setup

Docker Compose setup for a self-hosted XMPP chat server using Prosody. Includes PostgreSQL as the backend, TLS via Caddy, and a fairly complete module config — stream management, MAM (message history), file upload, push notifications, WebSocket/BOSH support.

> **Status: abandoned.** The official `prosody/prosody` Docker image is stuck on version 0.11 and hasn't been updated in years. Several modules (stream management XEP-0198, push XEP-0357, HTTP file upload) require 0.12+ to work properly. The server runs but those features are broken. I stopped here and moved on to look for a better-maintained XMPP solution for Docker.
>
> Leaving this here in case it's useful as a reference or starting point.

## What's configured

- **Prosody 0.11** — XMPP server
- **PostgreSQL 16** — message and roster storage
- **Caddy** — TLS termination and reverse proxy for WebSocket/BOSH/upload endpoints
- **Modules:** carbons, MAM, offline messages, file upload, BOSH, WebSocket, stream management, push notifications, CSI
- **Rate limiting** — 10kb/s client, 30kb/s server-to-server
- **Encryption enforced** — both c2s and s2s require TLS

## Setup

**1. Create directories**

```bash
mkdir -p /prosody_server/config
mkdir -p /prosody_server/logs
mkdir -p /mnt/data_storage/prosody_pgdata
```

Fix Postgres permissions (runs as UID 999):
```bash
sudo chown -R 999:999 /mnt/data_storage/prosody_pgdata
```

**2. Place your certificates**

Prosody expects certs issued separately — I used Caddy with Let's Encrypt:

```
/etc/prosody/certs/chat.domain.com.crt
/etc/prosody/certs/chat.domain.com.key
```

```bash
sudo chown -R 1000:1000 /etc/prosody/certs
sudo chmod 644 chat.domain.com.crt
sudo chmod 640 chat.domain.com.key
```

**3. Set your DB password** in both `docker-compose.yml` and `prosody.cfg.lua` — they must match.

> ⚠️ The DB password is in plain text in both files. Don't commit them with real credentials. Use a `.env` file for `docker-compose.yml` and keep `prosody.cfg.lua` out of version control, or replace the password with a placeholder before pushing.

**4. Create the external Docker network**

```bash
docker network create xmpp
```

**5. Start**

```bash
docker compose up -d
```

Logs are in `/prosody_server/logs`.

## Caddy config

```caddy
chat.domain.com {
  encode zstd gzip

  @ws    path /xmpp-websocket*
  @bosh  path /http-bind*
  @upload path /upload/*

  reverse_proxy @ws     http://prosody:5280
  reverse_proxy @bosh   http://prosody:5280
  reverse_proxy @upload http://prosody:5280
}
```

## Firewall (ufw)

```bash
sudo ufw allow 5222   # client connections
sudo ufw allow 5269   # server-to-server
sudo ufw allow 5280   # HTTP (BOSH/WebSocket/upload, proxied via Caddy)
sudo ufw allow 5281   # HTTPS
```

## Known issues (0.11 limitation)

- Stream Management (XEP-0198) — module loads but doesn't work reliably
- Push notifications (XEP-0357) — requires 0.12+
- HTTP File Upload (XEP-0363) — requires 0.12+

## Stack

Prosody · PostgreSQL · Docker · Caddy · XMPP
