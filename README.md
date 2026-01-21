# Team Status (Rails)

Tiny Rails app for tracking a team’s “what am I doing right now?” statuses.

## What it does

- Create a team (name → UUID + API keys)
- Add “team users” (not accounts; just username + optional profile pic URL)
- Post async status updates for users
- Query the current team status (for things like a menu bar app)
- Extremely simple HTML view at `/teams/:uuid`

## Requirements

- Ruby `3.2+`
- Bundler

## Setup (local)

```bash
cd team-status
bundle install
bin/rails db:prepare
```

Optional demo data (development only):

```bash
bin/rails db:seed
```

Run the server:

```bash
bin/rails server
```

## Deploying (Fly.io + Supabase Postgres)

This app is configured to use `DATABASE_URL` in production.

1) Create a Supabase project
- Supabase dashboard → Project → Settings → Database → Connection string
- Copy the Postgres connection **URI** (make sure it includes `sslmode=require`).

2) Set `DATABASE_URL` on Fly

```bash
fly secrets set DATABASE_URL='postgresql://USER:PASSWORD@HOST:PORT/postgres?sslmode=require'
```

3) Port configuration

Fly routes traffic to the port in `fly.toml` under `http_service.internal_port`.
This repo sets `PORT=8080` in `fly.toml`, so Puma binds correctly.

## Web UI

- Create a team: `http://localhost:3000/`
- Team page: `http://localhost:3000/teams/:uuid`

The team page lists users + their current status.

### Keys / Settings

- On team creation, the **secret key is shown once** (copy it then; it is not retrievable later because only a bcrypt digest is stored).
- The team page has a `⋯` menu:
  - **Add user** opens the add-user dialog.
  - **Settings** shows the **public key** and UUID.

## API Authentication

Every API request must include these headers:

- `X-Team-Public-Key`
- `X-Team-Secret-Key`

The secret key is only shown once on team creation.

## API Endpoints

Base path: `/api/v1/team`

### List users

`GET /api/v1/team/team_users`

```bash
curl -sS \
  -H "X-Team-Public-Key: PUBLIC" \
  -H "X-Team-Secret-Key: SECRET" \
  http://localhost:3000/api/v1/team/team_users
```

### Create user

`POST /api/v1/team/team_users`

```bash
curl -sS -X POST \
  -H "Content-Type: application/json" \
  -H "X-Team-Public-Key: PUBLIC" \
  -H "X-Team-Secret-Key: SECRET" \
  -d '{"team_user":{"username":"alice","profile_pic_url":"https://example.com/a.png"}}' \
  http://localhost:3000/api/v1/team/team_users
```

### Post a status update

`POST /api/v1/team/status_updates`

Body:

- `username` (required)
- `status` (required)
- `expires` (optional) — a datetime string parsed by Rails (`Time.zone.parse`), e.g. ISO-8601.

No expiry:

```bash
curl -sS -X POST \
  -H "Content-Type: application/json" \
  -H "X-Team-Public-Key: PUBLIC" \
  -H "X-Team-Secret-Key: SECRET" \
  -d '{"username":"alice","status":"Deep work"}' \
  http://localhost:3000/api/v1/team/status_updates
```

Expiry at a specific time (UTC example):

```bash
curl -sS -X POST \
  -H "Content-Type: application/json" \
  -H "X-Team-Public-Key: PUBLIC" \
  -H "X-Team-Secret-Key: SECRET" \
  -d '{"username":"alice","status":"In a meeting","expires":"2026-01-21T11:44:00Z"}' \
  http://localhost:3000/api/v1/team/status_updates
```

Expiry N minutes from now (bash example):

```bash
EXPIRES_AT=$(date -u -d "+60 minutes" +"%Y-%m-%dT%H:%M:%SZ")
curl -sS -X POST \
  -H "Content-Type: application/json" \
  -H "X-Team-Public-Key: PUBLIC" \
  -H "X-Team-Secret-Key: SECRET" \
  -d "{\"username\":\"alice\",\"status\":\"Back soon\",\"expires\":\"$EXPIRES_AT\"}" \
  http://localhost:3000/api/v1/team/status_updates
```

### Fetch current team status

`GET /api/v1/team/status`

```bash
curl -sS \
  -H "X-Team-Public-Key: PUBLIC" \
  -H "X-Team-Secret-Key: SECRET" \
  http://localhost:3000/api/v1/team/status
```

Response includes users with `status` and `updated_at` (based on each user’s latest status update).

## Tests

```bash
bin/rails test
```

## Notes

- Data model is intentionally small: `Team`, `TeamUser`, `StatusUpdate`.
- Team secret key is stored as a bcrypt digest (`secret_key_digest`).
